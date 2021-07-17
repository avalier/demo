namespace Avalier.Demo.Host.Services
{
    public static class LoadServiceExtensions
    {
        public static bool IsPrime(this int value) => ((long) value).IsPrime();
        
        public static bool IsPrime(this long value)
        {
            for (long i = 2; i < value; i += 1)
            {
                if (value % i == 0) return false;
            }
            return true;
        }
    }
}