
using Chat.Interfaces;
using Chat.Models;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace Chat.Services
{
    public class SendMail : ISendMail
    {
        private IConfiguration configuration;
        private SmtpClient client;
        private NetworkCredential login;
        private string mail;
        private string password;

        public SendMail(IConfiguration configuration)
        {
            this.configuration = configuration;
            mail = configuration.GetSection("SendMail").GetSection("Email").Value;
            password = configuration.GetSection("MailSender").GetSection("Password").Value;
            initConnection();
        }

        private void initConnection()
        {
            login = new NetworkCredential(mail, password);
            client = new SmtpClient("smt.gmail.com");
            client.Port = 587;
            client.EnableSsl = true;
            client.Credentials = login;
        }

        public string MailBody(string ime, string url)
        {
            var body = System.IO.File.ReadAllText("./Utils/EmailTemplates/NovKorisnik.html");
            body = body.Replace("#IME#", ime);
            body = body.Replace("#URL#", url);
            return body;
        }

        public bool SendMailNewUser(User user, string url)
        {
            Encoding encoding = Encoding.UTF8;
            string tema = "Kotarica";
            MailMessage poruka;
            initConnection();
            try
            {
                poruka = new MailMessage();
                poruka.From = new MailAddress(mail, "Kotarica", encoding);
                poruka.To.Add(new MailAddress(user.Email));
                poruka.Priority = MailPriority.High;
                poruka.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                poruka.IsBodyHtml = true;
                poruka.Subject = tema;
                poruka.Body = MailBody(user.email,  url);
                client.Send(poruka);
            }
            catch(Exception e)
            {
                Console.Out.Write(e.Message);
                return false;
            }
            return true;
        }
    }
}
