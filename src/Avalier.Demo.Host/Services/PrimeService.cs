using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace Avalier.Demo.Host.Services
{
    public class PrimeService : IPrimeService
    {
        public IEnumerable<long> GetPrimesUpTo(long index)
        {
            var primes = new List<long>();
            for (long i = 1; i <= index; i+=1)
            {
                if (i.IsPrime()) yield return i;
            }
        }

        public async Task<long> GetBiggestPrime(int milliseconds)
        {
            return await this.GetBiggestPrime(new TimeSpan(0, 0, 0, 0, milliseconds)).ConfigureAwait(true);
        }

        public async Task<long> GetBiggestPrime(TimeSpan timeSpan)
        {
            using (var cancellationTokenSource = new CancellationTokenSource(timeSpan))
            {
                return await this.GetBiggestPrime(cancellationTokenSource.Token).ConfigureAwait(true);
            }
        }
        
        public async Task<long> GetBiggestPrime(CancellationToken cancellationToken)
        {
            return await Task
                .Run(() => {
                    long prime = 1;
                    long i = 1;
                    while (!cancellationToken.IsCancellationRequested)
                    {
                        if (i.IsPrime()) prime = i;
                        i++;
                    }

                    return prime;
                })
                .ConfigureAwait(true);
        }
    }
}