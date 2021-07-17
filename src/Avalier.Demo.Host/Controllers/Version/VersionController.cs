using System;
using System.Linq;
using Microsoft.AspNetCore.Mvc;

namespace Avalier.Demo.Host.Controllers.Version
{
    [ApiController]
    [Route("api/version")]
    public class VersionController : ControllerBase
    {
        [HttpGet]
        [ProducesResponseType(typeof(string), 200)]
        public IActionResult Get()
        {
            var version = this.GetType().Assembly.GetName().Version;
            return Ok($"{version?.Major}.{version?.Minor}");
        }
    }
}
