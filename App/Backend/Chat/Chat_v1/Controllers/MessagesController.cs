using AutoMapper;
using Chat.Data;
using Chat.Hubs;
using Chat.Models;
using Chat_v1.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Chat_v1.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MessagesController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly IHubContext<ChatHub> _hubContext;
        private IMessage _message;
        

        public MessagesController(ApplicationDbContext context, IMessage messages, IHubContext<ChatHub> hubContext)
        {
            _message = messages;
            _context = context;
            
            _hubContext = hubContext;
        }

        [HttpGet]
        [Route("/api/messages/{korisnik}")]

        public IActionResult AllMessages(string korisnik)
        {
            var messages = _message.AllMessages(korisnik);
            if (messages != null)
            {
                return Ok(messages);
            }

            return NotFound($"Korisnik : ${korisnik} nije pronađen!");
        }

        [HttpGet("/api/privatechat/{user1}/{user2}")]
        public IActionResult PrivateChat(string user1, string user2)
        {
            var messages = _message.PrivateChat(user1, user2);
            if (messages != null)
            {
                Console.WriteLine("Poruka ok!");
                return Ok(messages);
            }

            return NotFound($"Ne postoji");
        }

        /*[HttpGet("{id}")]
        public async Task<ActionResult<User>> Get(int id)
        {
            var message = await _context.MessagesSqlite.FindAsync(id);
            /*if (message == null)
                return NotFound();

            var messageViewModel = _mapper.Map<Message, Message>(message);
            return Ok(messageViewModel);
            return NotFound();
        }*/

        [HttpPost]
        [Route("/api/messages")]

        public void AddMessage(Message message)
        {
            _message.NewMessage(message);

            //return Created(HttpContext.Request.Scheme + "://" + HttpContext.Request.Host + HttpContext.Request.Path + "/" + message.Id + message);
        }
        //AKouki
        /*[HttpPost]
        public async Task<ActionResult<Message>> Create(Message messageViewModel)
        {
            var user = _context.Users.FirstOrDefault(u => u.UserName == User.Identity.Name);
            var user2 = _context.Users.FirstOrDefault(r => r.UserName == User.Identity.Name);
            var msg = new Message()
            {
                Content = Regex.Replace(messageViewModel.Content, @"(?i)<(?!img|a|/a|/img).*?>", string.Empty),
                FromUser = user,
                ToUser = user2,
                Time = DateTime.Now
            };

            _context.Messages.Add(msg);
            await _context.SaveChangesAsync();

            // Broadcast the message
            var createdMessage = _mapper.Map<Message, Message>(msg);
            await _hubContext.Clients.Group(user2.Email).SendAsync("newMessage", createdMessage);

            return CreatedAtAction(nameof(Get), new { id = msg.ID }, createdMessage);
        }*/
    }
}

