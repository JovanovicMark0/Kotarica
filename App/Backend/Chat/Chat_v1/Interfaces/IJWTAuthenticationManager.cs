using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Chat.Interfaces
{
    public interface IJWTAuthenticationManager
    {
        string Authenticate(string Email, string password);
    }
}
