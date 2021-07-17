using System;
using System.Collections.Generic;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Avalier.Demo.Host.Services;
using Microsoft.AspNetCore.Mvc;
using Shouldly;
using Xunit;
using Xunit.Abstractions;

namespace Avalier.Demo.Host.Controllers.Prime
{
    public class VersionControllerTests
    {
        private readonly ITestOutputHelper _output;

        public VersionControllerTests(ITestOutputHelper output)
        {
            _output = output;
        }

        [Fact]
        public async Task CanGet()
        {
            var primeService = new PrimeService();
            var controller = new PrimeController(primeService);
            var response = (OkObjectResult)await controller.Get();
            _output.WriteLine($"{response.Value}");
            response.ShouldNotBeNull();
        }
    }
}
