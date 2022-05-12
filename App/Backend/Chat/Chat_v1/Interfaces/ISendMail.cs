using Chat.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Chat.Interfaces
{
    interface ISendMail
    {
        public bool SendMailNewUser(User user, string url);
    }
}
