using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.DataSet
{
    public class Context : IdentityDbContext
    {
       
        public DbSet<Korisnik> korisnici { get; set; }

        public Context(DbContextOptions<Context> options) : base(options) { }
    }
}
