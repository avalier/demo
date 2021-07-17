using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Shouldly;
using Xunit;
using Xunit.Abstractions;

namespace Avalier.Demo.Host.Services
{
    public class LoadServiceTests
    {
        private readonly ITestOutputHelper _output;

        public LoadServiceTests(ITestOutputHelper output)
        {
            _output = output;
        }

        [Fact]
        public void CanDeterminePrimesTo20()
        {
            1.IsPrime().ShouldBe(true);
            2.IsPrime().ShouldBe(true);
            3.IsPrime().ShouldBe(true);
            4.IsPrime().ShouldBe(false);
            5.IsPrime().ShouldBe(true);
            6.IsPrime().ShouldBe(false);
            7.IsPrime().ShouldBe(true);
            8.IsPrime().ShouldBe(false);
            9.IsPrime().ShouldBe(false);
            10.IsPrime().ShouldBe(false);
            11.IsPrime().ShouldBe(true);
            12.IsPrime().ShouldBe(false);
            13.IsPrime().ShouldBe(true);
            14.IsPrime().ShouldBe(false);
            15.IsPrime().ShouldBe(false);
            16.IsPrime().ShouldBe(false);
            17.IsPrime().ShouldBe(true);
            18.IsPrime().ShouldBe(false);
            19.IsPrime().ShouldBe(true);
            20.IsPrime().ShouldBe(false);
        }
        
        [Fact]
        public void CanGetPrimesTo11()
        {
            // 1, 2, 3, 5, 7, 11 //
            var service = new PrimeService();
            var response = service.GetPrimesUpTo(11).ToList();
            _output.WriteLine($"{response}");
            response.Count.ShouldBe(6);
        }

        [Fact]
        public async Task CanGetBiggestPrime()
        {
            var service = new PrimeService();
            var prime = await service.GetBiggestPrime(1000);
            _output.WriteLine($"Biggest prime: {prime}");
            prime.IsPrime().ShouldBe(true);
        }
    }
}