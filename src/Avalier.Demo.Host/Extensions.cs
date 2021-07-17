using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Primitives;
using Serilog;
using Serilog.Configuration;

namespace Avalier.Demo.Host
{
    [ExcludeFromCodeCoverage]
    [SuppressMessage("Microsoft.Design", "CA1724")]
    public static class Extensions
    {
        public static IApplicationBuilder UseOtlpResponseHeaders(this IApplicationBuilder app) {
            app.Use(async (context, next) =>
            {
                context.Response.OnStarting(() =>
                {
                    var activity = System.Diagnostics.Activity.Current;
                    context.Response.Headers.Add("X-Trace-Id", new StringValues(activity?.TraceId.ToString()));
                    context.Response.Headers.Add("X-Span-Id", new StringValues(activity?.SpanId.ToString()));
                    return Task.FromResult(0);
                });
                await next.Invoke();
            });
            return app;
        }
        
        public static LoggerConfiguration Evaluate(this LoggerSinkConfiguration loggerSinkConfiguration, Func<LoggerSinkConfiguration, LoggerConfiguration> evaluation)
        {
            if (null == evaluation) throw new ArgumentNullException(nameof(evaluation));
            return evaluation.Invoke(loggerSinkConfiguration);
        }

        public static IServiceCollection AddTransientByConvention(this IServiceCollection services, params Assembly[] assemblies)
        {
            // Default to entry assembly if no assemblies were specified //
            var items = assemblies.ToList();
            if (items.Count == 0) {
                var entryAssembly = Assembly.GetEntryAssembly();
                if (null != entryAssembly) items.Add(entryAssembly);
            }
            
            // Iterate through assemblies and register classes with matching interfaces //
            foreach (var assembly in assemblies)
            {
                var registrations = assembly.GetTypes()
                    .Where(t => t.IsClass && !t.IsGenericType && !t.IsAbstract)
                    .Where(t => null != t.GetInterface($"I{t.Name}"))
                    .Select(t => new { InterfaceType = t.GetInterface($"I{t.Name}"), ClassType = t})
                    .ToList();
                foreach (var registration in registrations)
                {
                    if (null != registration.InterfaceType) {
                        services.AddTransient(registration.InterfaceType, registration.ClassType);
                    }
                }
            }
            return services;
        }

        public static async Task<IEnumerable<T>> ToListAsync<T>(this IAsyncEnumerable<T> values)
        {
            if (null == values) throw new ArgumentNullException(nameof(values));
            var items = new List<T>();
            await foreach(var value in values) items.Add(value);
            return items;
        }
   
        public static string Merge(this IEnumerable<string> values, string separator) {
            if (null == values) throw new ArgumentNullException(nameof(values));
            var buffer = new StringBuilder();
            foreach (var value in values) {
                if (buffer.Length > 0) buffer.Append(separator);
                buffer.Append(value);
            }
            return buffer.ToString();
        }
    }

}
