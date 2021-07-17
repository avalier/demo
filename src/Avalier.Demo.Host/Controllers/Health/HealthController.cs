using System;
using System.Linq;
using Microsoft.AspNetCore.Mvc;

namespace Avalier.Demo.Host.Controllers.Health
{
    [ApiController]
    [Route("api/health")]
    [Route("api/healthz")]
    public class HealthController : ControllerBase
    {
        [HttpGet]
        [ProducesResponseType(200)]
        public IActionResult Get()
        {
            return Ok();
        }
    }
}