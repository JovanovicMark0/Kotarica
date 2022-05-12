using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using demoApp.Data;
using demoApp.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace demoApp.Controllers
{
    public class SeriesController : Controller
    {
        private readonly SeriesDbContext _context;
        public SeriesController(SeriesDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Series>>> GetSeries()
        {
            return await _context.Serieses.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Series>> GetSeries(int id)
        {
            var serieses = await _context.Serieses.FindAsync(id);

            if (serieses == null)
            {
                return NotFound();
            }

            return serieses;
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutSeries(int id, Series series)
        {
            if (id != series.ID)
            {
                return BadRequest();
            }
            _context.Entry(series).State = EntityState.Modified;
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SeriesExists(id))
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
        public async Task<ActionResult<Series>> PostSeries(Series series)
        {
            _context.Serieses.Add(series);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GerSeries", new { id = series.ID }, series);
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult<Series>> DeleteSeries(int id)
        {
            var series = await _context.Serieses.FindAsync(id);
            if (series == null)
            {
                return NotFound();
            }

            _context.Serieses.Remove(series);
            await _context.SaveChangesAsync();

            return series;
        }

        private bool SeriesExists(int id)
        {
            return _context.Serieses.Any(e => e.ID == id);
        }
    }
}
