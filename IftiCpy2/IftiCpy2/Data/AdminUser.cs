using System;

namespace IftiCpy.Data
{
    /// <summary>
    /// Represents an admin user for the portfolio admin panel
    /// </summary>
    public class AdminUser
    {
        public int Id { get; set; }
        
        public string Username { get; set; }
        
        public byte[] PasswordHash { get; set; }
        
        public DateTime CreatedAt { get; set; }
        
        public DateTime? LastLogin { get; set; }

        public AdminUser()
        {
            CreatedAt = DateTime.Now;
        }
    }

    /// <summary>
    /// Dashboard statistics model
    /// </summary>
    public class DashboardStats
    {
        public int ActiveProjects { get; set; }
        public int InactiveProjects { get; set; }
        public int ActiveBlogs { get; set; }
        public int InactiveBlogs { get; set; }
        public int UnreadMessages { get; set; }
        public int ReadMessages { get; set; }

        public int TotalProjects => ActiveProjects + InactiveProjects;
        public int TotalBlogs => ActiveBlogs + InactiveBlogs;
        public int TotalMessages => UnreadMessages + ReadMessages;
    }
}