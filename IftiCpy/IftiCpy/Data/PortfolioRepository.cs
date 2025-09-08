using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;

namespace IftiCpy.Data
{
    /// <summary>
    /// Repository for handling all database operations using ADO.NET
    /// </summary>
    public class PortfolioRepository
    {
        private readonly string _connectionString;

        public PortfolioRepository()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        }

        #region Project Operations

        /// <summary>
        /// Gets all active projects
        /// </summary>
        public List<Project> GetActiveProjects()
        {
            var projects = new List<Project>();

            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_GetActiveProjects", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                connection.Open();

                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        projects.Add(MapProjectFromReader(reader));
                    }
                }
            }

            return projects;
        }

        /// <summary>
        /// Gets all projects (active and inactive)
        /// </summary>
        public List<Project> GetAllProjects()
        {
            var projects = new List<Project>();

            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_GetAllProjects", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                connection.Open();

                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        projects.Add(MapProjectFromReader(reader));
                    }
                }
            }

            return projects;
        }

        /// <summary>
        /// Gets a project by ID
        /// </summary>
        public Project GetProjectById(int id)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_GetProjectById", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Id", id);
                connection.Open();

                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return MapProjectFromReader(reader);
                    }
                }
            }

            return null;
        }

        /// <summary>
        /// Inserts a new project
        /// </summary>
        public int InsertProject(Project project)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_InsertProject", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Title", project.Title);
                command.Parameters.AddWithValue("@Description", project.Description);
                command.Parameters.AddWithValue("@ImageUrl", (object)project.ImageUrl ?? DBNull.Value);
                command.Parameters.AddWithValue("@ProjectUrl", (object)project.ProjectUrl ?? DBNull.Value);
                command.Parameters.AddWithValue("@TechStack", (object)project.TechStack ?? DBNull.Value);
                command.Parameters.AddWithValue("@IsActive", project.IsActive);

                connection.Open();
                var result = command.ExecuteScalar();
                return Convert.ToInt32(result);
            }
        }

        /// <summary>
        /// Updates an existing project
        /// </summary>
        public void UpdateProject(Project project)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_UpdateProject", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Id", project.Id);
                command.Parameters.AddWithValue("@Title", project.Title);
                command.Parameters.AddWithValue("@Description", project.Description);
                command.Parameters.AddWithValue("@ImageUrl", (object)project.ImageUrl ?? DBNull.Value);
                command.Parameters.AddWithValue("@ProjectUrl", (object)project.ProjectUrl ?? DBNull.Value);
                command.Parameters.AddWithValue("@TechStack", (object)project.TechStack ?? DBNull.Value);
                command.Parameters.AddWithValue("@IsActive", project.IsActive);

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        /// <summary>
        /// Deletes a project
        /// </summary>
        public void DeleteProject(int id)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_DeleteProject", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Id", id);

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        #endregion

        #region BlogPost Operations

        /// <summary>
        /// Gets all active blog posts
        /// </summary>
        public List<BlogPost> GetActiveBlogPosts()
        {
            var blogPosts = new List<BlogPost>();

            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_GetActiveBlogPosts", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                connection.Open();

                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        blogPosts.Add(MapBlogPostFromReader(reader));
                    }
                }
            }

            return blogPosts;
        }

        /// <summary>
        /// Gets all blog posts (active and inactive)
        /// </summary>
        public List<BlogPost> GetAllBlogPosts()
        {
            var blogPosts = new List<BlogPost>();

            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_GetAllBlogPosts", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                connection.Open();

                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        blogPosts.Add(MapBlogPostFromReader(reader));
                    }
                }
            }

            return blogPosts;
        }

        /// <summary>
        /// Gets a blog post by ID
        /// </summary>
        public BlogPost GetBlogPostById(int id)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_GetBlogPostById", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Id", id);
                connection.Open();

                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return MapBlogPostFromReader(reader);
                    }
                }
            }

            return null;
        }

        /// <summary>
        /// Inserts a new blog post
        /// </summary>
        public int InsertBlogPost(BlogPost blogPost)
        {
            // Generate slug if not provided
            blogPost.GenerateSlug();

            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_InsertBlogPost", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Title", blogPost.Title);
                command.Parameters.AddWithValue("@Slug", blogPost.Slug);
                command.Parameters.AddWithValue("@Description", blogPost.Description);
                command.Parameters.AddWithValue("@Content", blogPost.Content);
                command.Parameters.AddWithValue("@ImageUrl", (object)blogPost.ImageUrl ?? DBNull.Value);
                command.Parameters.AddWithValue("@Platform", (object)blogPost.Platform ?? DBNull.Value);
                command.Parameters.AddWithValue("@IsActive", blogPost.IsActive);

                connection.Open();
                var result = command.ExecuteScalar();
                return Convert.ToInt32(result);
            }
        }

        /// <summary>
        /// Updates an existing blog post
        /// </summary>
        public void UpdateBlogPost(BlogPost blogPost)
        {
            // Generate slug if not provided
            blogPost.GenerateSlug();

            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_UpdateBlogPost", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Id", blogPost.Id);
                command.Parameters.AddWithValue("@Title", blogPost.Title);
                command.Parameters.AddWithValue("@Slug", blogPost.Slug);
                command.Parameters.AddWithValue("@Description", blogPost.Description);
                command.Parameters.AddWithValue("@Content", blogPost.Content);
                command.Parameters.AddWithValue("@ImageUrl", (object)blogPost.ImageUrl ?? DBNull.Value);
                command.Parameters.AddWithValue("@Platform", (object)blogPost.Platform ?? DBNull.Value);
                command.Parameters.AddWithValue("@IsActive", blogPost.IsActive);

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        /// <summary>
        /// Deletes a blog post
        /// </summary>
        public void DeleteBlogPost(int id)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_DeleteBlogPost", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Id", id);

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        #endregion

        #region ContactMessage Operations

        /// <summary>
        /// Gets all contact messages
        /// </summary>
        public List<ContactMessage> GetAllContactMessages()
        {
            var messages = new List<ContactMessage>();

            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_GetAllContactMessages", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                connection.Open();

                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        messages.Add(MapContactMessageFromReader(reader));
                    }
                }
            }

            return messages;
        }

        /// <summary>
        /// Inserts a new contact message
        /// </summary>
        public int InsertContactMessage(ContactMessage message)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_InsertContactMessage", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Name", message.Name);
                command.Parameters.AddWithValue("@Email", message.Email);
                command.Parameters.AddWithValue("@Subject", message.Subject);
                command.Parameters.AddWithValue("@Message", message.Message);

                connection.Open();
                var result = command.ExecuteScalar();
                return Convert.ToInt32(result);
            }
        }

        /// <summary>
        /// Marks a contact message as read
        /// </summary>
        public void MarkMessageAsRead(int id)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_MarkMessageAsRead", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Id", id);

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        /// <summary>
        /// Deletes a contact message
        /// </summary>
        public void DeleteContactMessage(int id)
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_DeleteContactMessage", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Id", id);

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        #endregion

        #region Admin Operations

        /// <summary>
        /// Validates admin credentials
        /// </summary>
        public AdminUser ValidateAdminCredentials(string username, string password)
        {
            var passwordHash = ComputeSHA256Hash(password);

            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_ValidateAdminCredentials", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Username", username);
                command.Parameters.AddWithValue("@PasswordHash", passwordHash);

                connection.Open();

                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new AdminUser
                        {
                            Id = reader.GetInt32(0), // Id
                            Username = reader.GetString(1) // Username
                        };
                    }
                }
            }

            return null;
        }

        /// <summary>
        /// Gets dashboard statistics
        /// </summary>
        public DashboardStats GetDashboardStats()
        {
            using (var connection = new SqlConnection(_connectionString))
            using (var command = new SqlCommand("sp_GetDashboardStats", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                connection.Open();

                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new DashboardStats
                        {
                            ActiveProjects = reader.GetInt32(0), // ActiveProjects
                            InactiveProjects = reader.GetInt32(1), // InactiveProjects
                            ActiveBlogs = reader.GetInt32(2), // ActiveBlogs
                            InactiveBlogs = reader.GetInt32(3), // InactiveBlogs
                            UnreadMessages = reader.GetInt32(4), // UnreadMessages
                            ReadMessages = reader.GetInt32(5) // ReadMessages
                        };
                    }
                }
            }

            return new DashboardStats();
        }

        #endregion

        #region Helper Methods

        /// <summary>
        /// Maps a SqlDataReader to a Project object
        /// </summary>
        private Project MapProjectFromReader(SqlDataReader reader)
        {
            return new Project
            {
                Id = reader.GetInt32(0), // Id
                Title = reader.GetString(1), // Title
                Description = reader.GetString(2), // Description
                ImageUrl = reader.IsDBNull(3) ? null : reader.GetString(3), // ImageUrl
                ProjectUrl = reader.IsDBNull(4) ? null : reader.GetString(4), // ProjectUrl
                TechStack = reader.IsDBNull(5) ? null : reader.GetString(5), // TechStack
                IsActive = reader.GetBoolean(6), // IsActive
                CreatedAt = reader.GetDateTime(7), // CreatedAt
                UpdatedAt = reader.GetDateTime(8) // UpdatedAt
            };
        }

        /// <summary>
        /// Maps a SqlDataReader to a BlogPost object
        /// </summary>
        private BlogPost MapBlogPostFromReader(SqlDataReader reader)
        {
            return new BlogPost
            {
                Id = reader.GetInt32(0), // Id
                Title = reader.GetString(1), // Title
                Slug = reader.GetString(2), // Slug
                Description = reader.GetString(3), // Description
                Content = reader.GetString(4), // Content
                ImageUrl = reader.IsDBNull(5) ? null : reader.GetString(5), // ImageUrl
                Platform = reader.IsDBNull(6) ? null : reader.GetString(6), // Platform
                IsActive = reader.GetBoolean(7), // IsActive
                CreatedAt = reader.GetDateTime(8), // CreatedAt
                UpdatedAt = reader.GetDateTime(9) // UpdatedAt
            };
        }

        /// <summary>
        /// Maps a SqlDataReader to a ContactMessage object
        /// </summary>
        private ContactMessage MapContactMessageFromReader(SqlDataReader reader)
        {
            return new ContactMessage
            {
                Id = reader.GetInt32(0), // Id
                Name = reader.GetString(1), // Name
                Email = reader.GetString(2), // Email
                Subject = reader.GetString(3), // Subject
                Message = reader.GetString(4), // Message
                IsRead = reader.GetBoolean(5), // IsRead
                CreatedAt = reader.GetDateTime(6) // CreatedAt
            };
        }

        /// <summary>
        /// Computes SHA256 hash of a string
        /// </summary>
        private byte[] ComputeSHA256Hash(string input)
        {
            using (var sha256 = SHA256.Create())
            {
                return sha256.ComputeHash(Encoding.UTF8.GetBytes(input));
            }
        }

        #endregion
    }
}