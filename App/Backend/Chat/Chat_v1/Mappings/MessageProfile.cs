using Chat.Models;
using Chat.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using Chat.Web.Helpers;

namespace Chat.Mappings
{
    public class MessageProfile :Profile
    {
        /*public MessageProfile()
        {
            CreateMap<Message, MessageView>()
                .ForMember(dst => dst.From, opt => opt.MapFrom(x => x.FromUser.FullName))
                .ForMember(dst => dst.To, opt => opt.MapFrom(x => x.ToUser.FullName))
                .ForMember(dst => dst.Content, opt => opt.MapFrom(x => BasicEmojis.ParseEmojis(x.Content)))
                .ForMember(dst => dst.Time, opt => opt.MapFrom(x => x.Time));
            CreateMap<MessageView, Message>();
        }*/
    }
}
