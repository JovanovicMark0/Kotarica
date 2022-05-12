using Chat.Data;
using Chat.Hubs;
using Chat.Interfaces;
using Chat.Models;
using Chat.Services;
using Chat_v1.Data;
using Chat_v1.Handlers;
using Chat_v1.Interfaces;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Chat_v1
{
   public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //baza
            //services.AddDbContext<ApplicationDbContext>(options => options.UseSqlite("Data Source=Chat.db"));
            //services.AddHealthChecks().AddDbContextCheck<ApplicationDbContext>();

            //JNK ADD
            //services.AddDbContext<ApplicationDbContext>(options => options.UseSqlite("Data Source=Chat.db"));

            //JNK
            services.AddControllers();
            //services.AddDbContext<ApplicationDbContext>(options => options.UseSqlite("Data Source = chat.db"));
            services.AddDbContext<ApplicationDbContext>(options => options.UseSqlite(Configuration.GetConnectionString("ChatConnString")));
            services.AddScoped<IMessage, MessagesDatabaseQuery>();

            services.AddIdentity<IdentityUser, IdentityRole>()
            .AddDefaultUI()
            .AddEntityFrameworkStores<ApplicationDbContext>()
            .AddDefaultTokenProviders();
            
            //services.AddScoped<IMessageData, SqlMessageData>();
            //< ICommentData, SqlCommentData
            //IUserData, SqlUserData
            //IWishData, SqlWishData

            //JNK END
            //Sve veze
            //services.AddTransient<IKategorije, KategorijeRepo>();
            //services.AddTransient<IProizvodi, ProizvodiRepo>();
            /* services.AddSwaggerGen(options =>
             {
                 options.SwaggerDoc("v1", new OpenApiInfo { Title = "Kotarica", Version = "v1" });
             });*/

            //services.AddScoped<ISendMail, SendMail>();
            
        

        

            //tokeni START
            var key = "Secret key"; 
            /*services.AddAuthentication(x =>
            {
                x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(x =>
            {
                x.RequireHttpsMetadata = false;
                x.SaveToken = true;
                x.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(key)),
                    ValidateIssuer = false,
                    ValidateAudience = false
                };
            });*/

           //JNK TOKENI
            services.AddAuthentication("BasicAuthentication").AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);
            //JNK END
            services.AddSingleton<IJWTAuthenticationManager>(new JWTAuthenticationManager(key));            //tokeni END

            //CHATT START
            services.AddSignalR();

            services.AddCors(options =>
            {
                options.AddPolicy("_allowAnyOrigin",
                                  builder =>
                                  {
                                      builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
                                  });
            });
            //CHAT END

        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IServiceProvider serviceProvider)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                //app.UseSwagger();
                //app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "Chat v1"));
            }

            //app.UseSwagger();

            //app.UseHttpsRedirection();

            app.UseRouting();

            app.UseCors("_allowAnyOrigin");

            app.UseAuthorization();


            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });


            //CHAT START
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapHub<ChatHub>("/chatter");
            });
            //CHAT END
        }
    }
}
