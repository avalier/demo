using System;
using System.Collections.Generic;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Shouldly;
using Xunit;
using Xunit.Abstractions;

namespace Avalier.Demo.Host.Controllers.Health
{
    public class HealthControllerTests
    {
        [Fact]
        public void CanGet()
        {
            var controller = new HealthController();
            var response = (OkResult)controller.Get();
            response.ShouldNotBeNull();
        }
    }
}