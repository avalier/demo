using System.Collections.Generic;

namespace Avalier.Demo.Host.Services
{
    public interface IPrimeService
    {
        IEnumerable<long> GetPrimesUpTo(long index);
    }
}