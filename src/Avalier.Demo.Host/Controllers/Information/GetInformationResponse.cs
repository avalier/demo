using System.Collections.Generic;

namespace Avalier.Demo.Host.Controllers.Information
{
    public class GetInformationResponse
    {
        public string Version { get; internal set; } = "";
        
        public string Name { get; internal set; } = "";
        
        public string Hostname { get; internal set; } = "";
        
        public List<string> Addresses { get; internal set; } = new List<string>();
    }
}
