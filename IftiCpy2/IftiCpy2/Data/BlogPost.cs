using System;

namespace IftiCpy.Data
{
    /// <summary>
    /// Represents a blog post in the portfolio
    /// </summary>
    public class BlogPost
    {
        public int Id { get; set; }
        
        public string Title { get; set; }
        
        public string Slug { get; set; }
        
        public string Description { get; set; }
        
        public string Content { get; set; }
        
        public string ImageUrl { get; set; }
        
        public string Platform { get; set; }
        
        public bool IsActive { get; set; }
        
        public DateTime CreatedAt { get; set; }
        
        public DateTime UpdatedAt { get; set; }

        public BlogPost()
        {
            IsActive = true;
            CreatedAt = DateTime.Now;
            UpdatedAt = DateTime.Now;
        }

        /// <summary>
        /// Generates a URL-friendly slug from the title
        /// </summary>
        public void GenerateSlug()
        {
            if (string.IsNullOrEmpty(Slug) && !string.IsNullOrEmpty(Title))
            {
                Slug = Title.ToLower()
                    .Replace(" ", "-")
                    .Replace(":", "")
                    .Replace("?", "")
                    .Replace("!", "")
                    .Replace(",", "")
                    .Replace(".", "")
                    .Replace("'", "")
                    .Replace("\"", "");
            }
        }
    }
}