using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace Avalier.Demo.Host.Controllers.Information
{
    [ApiController]
    [Route("api/information")]
    public class InformationController : ControllerBase
    {
        [HttpGet]
        [ProducesResponseType(typeof(GetInformationResponse), 200)]
        public IActionResult Get()
        {
            var response = new GetInformationResponse()
            {
                Version = this.GetType()?.Assembly?.GetName()?.Version?.ToString() ?? "",
                Name = (this.GetType()?.AssemblyQualifiedName ?? "").Split(", ").Skip(1).First(),
                Hostname = Dns.GetHostName(),
                Addresses = Dns.GetHostAddresses(Dns.GetHostName()).Select( o => o.ToString()).OrderBy(o => o).ToList()
            };
            return Ok(response);
        }
        
    }
}
