using Newtonsoft.Json;

namespace Avalier.Demo.Host
{
    public static class Extensions
    {
        public static string ToJson<T>(this T value)
        {
            return JsonConvert.SerializeObject(value);
        }
    }
}
