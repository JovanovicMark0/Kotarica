using System;
using System.Collections.Generic;
using System.Text;
using demoApp.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace demoApp.Data
{
    public class SeriesDbContext : IdentityDbContext
    {
        public DbSet<Users> Userss { get; set; }
        public DbSet<Series> Serieses { get; set; }
        public SeriesDbContext(DbContextOptions<SeriesDbContext> options)
            : base(options)
        {
        }

    }
}
