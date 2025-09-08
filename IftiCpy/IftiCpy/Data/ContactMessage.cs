using System;

namespace IftiCpy.Data
{
    /// <summary>
    /// Represents a contact message from the portfolio contact form
    /// </summary>
    public class ContactMessage
    {
        public int Id { get; set; }
        
        public string Name { get; set; }
        
        public string Email { get; set; }
        
        public string Subject { get; set; }
        
        public string Message { get; set; }
        
        public bool IsRead { get; set; }
        
        public DateTime CreatedAt { get; set; }

        public ContactMessage()
        {
            IsRead = false;
            CreatedAt = DateTime.Now;
        }
    }
}