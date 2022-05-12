using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace demoApp.Models
{
    public class Series
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Genre { get; set; }
        public string TheDirector { get; set; }
        public int BeginYear { get; set; }
        public int EndYear { get; set; }
    }
}
