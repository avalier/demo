using System;
using System.Collections.Generic;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Shouldly;
using Xunit;
using Xunit.Abstractions;

namespace Avalier.Demo.Host.Controllers.Version
{
    public class VersionControllerTests
    {
        private readonly ITestOutputHelper _output;

        public VersionControllerTests(ITestOutputHelper output)
        {
            _output = output;
        }

        [Fact]
        public void CanGet()
        {
            var controller = new VersionController();
            var response = (OkObjectResult)controller.Get();

            _output.WriteLine($"{response.Value}");

            var version = typeof(VersionController).Assembly.GetName().Version;
            response.ShouldNotBeNull();
            response.Value.ShouldBe($"{version.Major}.{version.Minor}");
        }
    }
}