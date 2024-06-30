using Microsoft.EntityFrameworkCore;
using TodoNow.Domain.Models;
using TodoNow.Infra.Data.Configurations;

namespace TodoNow.Infra.Data;

public class ApplicationDbContext : DbContext
{
    public DbSet<User> Users { get; set; }

    public ApplicationDbContext(DbContextOptions options) : base(options)
    {
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfiguration(new UserConfiguration());
    }
}