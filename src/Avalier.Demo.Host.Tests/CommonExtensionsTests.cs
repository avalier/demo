using System;
using Xunit;
using Shouldly;

namespace Avalier.Demo.Host
{
    public class CommonExtensionsTests
    {
        [Fact]
        public void ThrowIfNull_Should_Succeed_If_NotNull()
        {
            // Arrange //
            var o = new object();
            
            // Act //
            var p = o.ThrowIfNull("o");
            
            // Assert //
            p.ShouldBe(o);
        }
        
        [Fact]
        public void ThrowIfNull_Should_Throw_If_Null()
        {
            // Arrange //
            Object o = null;
            
            // Act & Assert //
            var x = Assert.Throws<ArgumentNullException>(() => o.ThrowIfNull("o"));
            
            // Assert //
            x.ParamName.ShouldBe("o");
        }
    }
}
