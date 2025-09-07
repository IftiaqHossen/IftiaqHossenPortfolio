using System;

namespace IftiCpy.Data
{
    /// <summary>
    /// Represents a project in the portfolio
    /// </summary>
    public class Project
    {
        public int Id { get; set; }
        
        public string Title { get; set; }
        
        public string Description { get; set; }
        
        public string ImageUrl { get; set; }
        
        public string ProjectUrl { get; set; }
        
        public string TechStack { get; set; }
        
        public bool IsActive { get; set; }
        
        public DateTime CreatedAt { get; set; }
        
        public DateTime UpdatedAt { get; set; }

        public Project()
        {
            IsActive = true;
            CreatedAt = DateTime.Now;
            UpdatedAt = DateTime.Now;
        }
    }
}