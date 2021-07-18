using System;
using System.Collections.Generic;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Shouldly;
using Xunit;
using Xunit.Abstractions;

namespace Avalier.Demo.Host.Controllers.Information
{
    public class InformationControllerTests
    {
        private readonly ITestOutputHelper _output;

        public InformationControllerTests(ITestOutputHelper output)
        {
            _output = output;
        }

        [Fact]
        public void CanGet()
        {
            var controller = new InformationController();
            var response = (OkObjectResult)controller.Get();

            _output.WriteLine($"{response.Value.ToJson()}");
            response.ShouldNotBeNull();
        }
    }
}
