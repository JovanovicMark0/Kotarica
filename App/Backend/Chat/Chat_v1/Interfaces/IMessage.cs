using Chat.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Chat_v1.Interfaces
{
    public interface IMessage
    {
        public List<Message> AllMessages(string user);
        public List<Message> PrivateChat(string user1, string user2);
        public Message NewMessage(Message message);
    }
}
