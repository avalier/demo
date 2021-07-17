using System;

namespace Avalier.Demo
{
    public static class Extensions
    {
        public static T ThrowIfNull<T>(this T? value, string paramName)
        {
            if (null == value)
            {
                throw new ArgumentNullException(paramName);
            }

            return value;
        }
    }
}
