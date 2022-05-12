using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DataSet
{
    public class Login
    {
        [Required]
        public String email { get; set; }
        [Required]
        public String pass { get; set; }
    }
}
