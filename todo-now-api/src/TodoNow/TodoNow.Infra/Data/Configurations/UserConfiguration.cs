using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using TodoNow.Domain.Models;

namespace TodoNow.Infra.Data.Configurations;

public class UserConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> entity)
    {
        entity.ToTable("tb_users");
        entity.HasKey(u => u.Id).HasName("pk_users");

        entity.Property(u => u.Id)
            .HasColumnName("id")
            .HasColumnType("int")
            .ValueGeneratedOnAdd();

        entity.Property(u => u.Name)
            .HasColumnName("name")
            .HasColumnType("nvarchar(80)");

        entity.Property(u => u.Email)
            .HasColumnName("email")
            .HasColumnType("nvarchar(100)");

        entity.Property(u => u.Password)
            .HasColumnName("password")
            .HasColumnType("nvarchar(100)");
    }
}