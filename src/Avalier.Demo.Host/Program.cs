using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Configuration;
using Serilog.Events;
using Serilog.Formatting.Compact;
using Serilog.Enrichers.Span;

namespace Avalier.Demo.Host
{
    [ExcludeFromCodeCoverage]
    [SuppressMessage("Microsoft.Design", "CA1031")]
    public static class Program
    {
        public static bool IsDevelopment() => Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Development";
        
        public static int Main(string[] args)
        {
            // Setup OpenTelemetry //
            System.Diagnostics.Activity.DefaultIdFormat = ActivityIdFormat.W3C;
            System.Diagnostics.Activity.ForceDefaultIdFormat = true;

            // Setup Logging (Serilog) //
            Serilog.Log.Logger = new LoggerConfiguration()
                .MinimumLevel.Debug()
                .MinimumLevel.Override("Microsoft", LogEventLevel.Information)
                .Enrich.FromLogContext()
                .Enrich.WithSpan()
                .WriteTo.Evaluate(o => IsDevelopment()
                    ? o.Console()
                    : o.Console(formatter: new CompactJsonFormatter())
                )
                .CreateLogger();

            // Log assemblies (to force inclusion for DI) //
            LogAssemblies(
                typeof(Avalier.Demo.Extensions).Assembly // Avalier.Demo //
            );
            
            try
            {
                Log.Information("Starting host");
                CreateHostBuilder(args).Build().Run();
                Log.Information("Stopped host");
                return 0;
            }
            catch (Exception x)
            {
                Log.Fatal(x, "Host terminated (due to exception)");
                return 1;
            }
            finally
            {

                Log.CloseAndFlush();
            }
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Microsoft.Extensions.Hosting.Host.CreateDefaultBuilder(args)
                .UseSerilog()
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
        
        public static void LogAssemblies(params Assembly[] assemblies)
        {
            foreach (var assembly in assemblies)
            {
                Serilog.Log.Logger.Information("Referencing assembly: {Assembly}", assembly.GetName().Name);
            } 
        }
    }
}
