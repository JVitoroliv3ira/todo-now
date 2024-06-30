using Microsoft.EntityFrameworkCore;
using TodoNow.Infra.Data;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddControllers();

var connectionString = builder.Configuration.GetConnectionString("SqlServerConnection");

builder.Services.AddDbContext<ApplicationDbContext>(o => o.UseSqlServer(connectionString));

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var context = services.GetRequiredService<ApplicationDbContext>();
    var migracaoConnectionString = builder.Configuration.GetConnectionString("MigracaoSqlServerConnection");

    if (!string.IsNullOrEmpty(migracaoConnectionString))
    {
        context.Database.SetConnectionString(migracaoConnectionString);
    }

    context.Database.Migrate();
}

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UsePathBase("/apí");
app.MapControllers();

app.Run();