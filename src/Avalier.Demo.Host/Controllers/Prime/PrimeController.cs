using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace Avalier.Demo.Host.Controllers.Prime
{
    [ApiController]
    [Route("api/prime")]
    public class PrimeController : ControllerBase
    {
        private readonly Services.PrimeService _primeService;

        public PrimeController(Services.PrimeService primeService)
        {
            _primeService = primeService;
        }

        [HttpGet()]
        [ProducesResponseType(typeof(long), 200)]
        public async Task<IActionResult> Get(int milliseconds = 1000)
        {
            var prime = await _primeService.GetBiggestPrime(milliseconds).ConfigureAwait(true);
            return Ok(prime);
        }
        
    }
}