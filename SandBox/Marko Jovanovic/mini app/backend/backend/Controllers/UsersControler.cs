using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backend.DataSet;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace demoApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly Context _context;

        public UserController(Context context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Korisnik>>> GerUsers()
        {
            return await _context.korisnici.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Korisnik>> GetUsers(int id)
        {
            var users = await _context.korisnici.FindAsync(id);

            if (users == null)
            {
                return NotFound();
            }

            return users;
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutUsers(int id, Korisnik users)
        {
            if (id != users.Id)
            {
                return BadRequest();
            }

            _context.Entry(users).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UsersExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        [HttpPost]
        public async Task<ActionResult<Korisnik>> PostUsers(Korisnik users)
        {
            _context.korisnici.Add(users);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUsers", new { id = users.Id }, users);
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult<Korisnik>> DeleteUsers(int id)
        {
            var users = await _context.korisnici.FindAsync(id);
            if (users == null)
            {
                return NotFound();
            }

            _context.korisnici.Remove(users);
            await _context.SaveChangesAsync();

            return users;
        }

        private bool UsersExists(int id)
        {
            return _context.korisnici.Any(e => e.Id == id);
        }
    }
}
