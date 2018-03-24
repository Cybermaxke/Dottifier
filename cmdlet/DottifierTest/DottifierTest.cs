using System;
using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using Dottifier;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace DottifierTest
{
    [TestClass]
    public class DottifierTest
    {

        private RunspaceConfiguration config;

        [TestInitialize]
        public void Initialize()
        {
            config = RunspaceConfiguration.Create();
            config.Cmdlets.Append(new CmdletConfigurationEntry("Get-Dottified", typeof(GetDottified), null));
        }
        /*
        [TestMethod]
        public void Test()
        {
            using (Runspace rs = RunspaceFactory.CreateRunspace(config))
            {
                rs.Open();
                using (Pipeline p = rs.CreatePipeline("Get-Dottified -Text Seppe | Write-Output"))
                {
                    p.Invoke();
                }
            }
        }*/

        [TestMethod]
        public void TestB()
        {
            GetDottified getDottified = new GetDottified();
            getDottified.Text = "Seppe";
            getDottified.Invoke();
        }
    }
}
