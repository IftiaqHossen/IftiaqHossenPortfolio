-- Portfolio Database Creation Script
-- Run this script to create the PortfolioDB database and required tables

-- Create Database
USE master;
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'PortfolioDB')
BEGIN
    DROP DATABASE PortfolioDB;
END
GO

CREATE DATABASE PortfolioDB;
GO

USE PortfolioDB;
GO

-- Create AdminUsers Table
CREATE TABLE AdminUsers (
    Id int IDENTITY(1,1) PRIMARY KEY,
    Username nvarchar(50) NOT NULL UNIQUE,
    PasswordHash varbinary(32) NOT NULL,
    CreatedAt datetime2 DEFAULT GETDATE(),
    LastLogin datetime2 NULL
);

-- Create Projects Table
CREATE TABLE Projects (
    Id int IDENTITY(1,1) PRIMARY KEY,
    Title nvarchar(100) NOT NULL,
    Description nvarchar(500) NOT NULL,
    ImageUrl nvarchar(255) NULL,
    ProjectUrl nvarchar(255) NULL,
    TechStack nvarchar(200) NULL,
    IsActive bit DEFAULT 1,
    CreatedAt datetime2 DEFAULT GETDATE(),
    UpdatedAt datetime2 DEFAULT GETDATE()
);

-- Create BlogPosts Table
CREATE TABLE BlogPosts (
    Id int IDENTITY(1,1) PRIMARY KEY,
    Title nvarchar(150) NOT NULL,
    Slug nvarchar(150) NOT NULL UNIQUE,
    Description nvarchar(300) NOT NULL,
    Content nvarchar(MAX) NOT NULL,
    ImageUrl nvarchar(255) NULL,
    Platform nvarchar(50) NULL,
    IsActive bit DEFAULT 1,
    CreatedAt datetime2 DEFAULT GETDATE(),
    UpdatedAt datetime2 DEFAULT GETDATE()
);

-- Create ContactMessages Table
CREATE TABLE ContactMessages (
    Id int IDENTITY(1,1) PRIMARY KEY,
    Name nvarchar(100) NOT NULL,
    Email nvarchar(100) NOT NULL,
    Subject nvarchar(150) NOT NULL,
    Message nvarchar(MAX) NOT NULL,
    IsRead bit DEFAULT 0,
    CreatedAt datetime2 DEFAULT GETDATE()
);

-- Create Stored Procedures for Projects
GO
CREATE PROCEDURE sp_GetActiveProjects
AS
BEGIN
    SELECT Id, Title, Description, ImageUrl, ProjectUrl, TechStack, IsActive, CreatedAt, UpdatedAt
    FROM Projects 
    WHERE IsActive = 1
    ORDER BY CreatedAt DESC;
END
GO

CREATE PROCEDURE sp_GetAllProjects
AS
BEGIN
    SELECT Id, Title, Description, ImageUrl, ProjectUrl, TechStack, IsActive, CreatedAt, UpdatedAt
    FROM Projects
    ORDER BY CreatedAt DESC;
END
GO

CREATE PROCEDURE sp_GetProjectById
    @Id int
AS
BEGIN
    SELECT Id, Title, Description, ImageUrl, ProjectUrl, TechStack, IsActive, CreatedAt, UpdatedAt
    FROM Projects 
    WHERE Id = @Id;
END
GO

CREATE PROCEDURE sp_InsertProject
    @Title nvarchar(100),
    @Description nvarchar(500),
    @ImageUrl nvarchar(255) = NULL,
    @ProjectUrl nvarchar(255) = NULL,
    @TechStack nvarchar(200) = NULL,
    @IsActive bit = 1
AS
BEGIN
    INSERT INTO Projects (Title, Description, ImageUrl, ProjectUrl, TechStack, IsActive, UpdatedAt)
    VALUES (@Title, @Description, @ImageUrl, @ProjectUrl, @TechStack, @IsActive, GETDATE());
    SELECT SCOPE_IDENTITY() AS NewId;
END
GO

CREATE PROCEDURE sp_UpdateProject
    @Id int,
    @Title nvarchar(100),
    @Description nvarchar(500),
    @ImageUrl nvarchar(255) = NULL,
    @ProjectUrl nvarchar(255) = NULL,
    @TechStack nvarchar(200) = NULL,
    @IsActive bit = 1
AS
BEGIN
    UPDATE Projects 
    SET Title = @Title,
        Description = @Description,
        ImageUrl = @ImageUrl,
        ProjectUrl = @ProjectUrl,
        TechStack = @TechStack,
        IsActive = @IsActive,
        UpdatedAt = GETDATE()
    WHERE Id = @Id;
END
GO

CREATE PROCEDURE sp_DeleteProject
    @Id int
AS
BEGIN
    DELETE FROM Projects WHERE Id = @Id;
END
GO

-- Create Stored Procedures for BlogPosts
CREATE PROCEDURE sp_GetActiveBlogPosts
AS
BEGIN
    SELECT Id, Title, Slug, Description, Content, ImageUrl, Platform, IsActive, CreatedAt, UpdatedAt
    FROM BlogPosts 
    WHERE IsActive = 1
    ORDER BY CreatedAt DESC;
END
GO

CREATE PROCEDURE sp_GetAllBlogPosts
AS
BEGIN
    SELECT Id, Title, Slug, Description, Content, ImageUrl, Platform, IsActive, CreatedAt, UpdatedAt
    FROM BlogPosts
    ORDER BY CreatedAt DESC;
END
GO

CREATE PROCEDURE sp_GetBlogPostById
    @Id int
AS
BEGIN
    SELECT Id, Title, Slug, Description, Content, ImageUrl, Platform, IsActive, CreatedAt, UpdatedAt
    FROM BlogPosts 
    WHERE Id = @Id;
END
GO

CREATE PROCEDURE sp_InsertBlogPost
    @Title nvarchar(150),
    @Slug nvarchar(150),
    @Description nvarchar(300),
    @Content nvarchar(MAX),
    @ImageUrl nvarchar(255) = NULL,
    @Platform nvarchar(50) = NULL,
    @IsActive bit = 1
AS
BEGIN
    INSERT INTO BlogPosts (Title, Slug, Description, Content, ImageUrl, Platform, IsActive, UpdatedAt)
    VALUES (@Title, @Slug, @Description, @Content, @ImageUrl, @Platform, @IsActive, GETDATE());
    SELECT SCOPE_IDENTITY() AS NewId;
END
GO

CREATE PROCEDURE sp_UpdateBlogPost
    @Id int,
    @Title nvarchar(150),
    @Slug nvarchar(150),
    @Description nvarchar(300),
    @Content nvarchar(MAX),
    @ImageUrl nvarchar(255) = NULL,
    @Platform nvarchar(50) = NULL,
    @IsActive bit = 1
AS
BEGIN
    UPDATE BlogPosts 
    SET Title = @Title,
        Slug = @Slug,
        Description = @Description,
        Content = @Content,
        ImageUrl = @ImageUrl,
        Platform = @Platform,
        IsActive = @IsActive,
        UpdatedAt = GETDATE()
    WHERE Id = @Id;
END
GO

CREATE PROCEDURE sp_DeleteBlogPost
    @Id int
AS
BEGIN
    DELETE FROM BlogPosts WHERE Id = @Id;
END
GO

-- Create Stored Procedures for ContactMessages
CREATE PROCEDURE sp_GetAllContactMessages
AS
BEGIN
    SELECT Id, Name, Email, Subject, Message, IsRead, CreatedAt
    FROM ContactMessages
    ORDER BY CreatedAt DESC;
END
GO

CREATE PROCEDURE sp_InsertContactMessage
    @Name nvarchar(100),
    @Email nvarchar(100),
    @Subject nvarchar(150),
    @Message nvarchar(MAX)
AS
BEGIN
    INSERT INTO ContactMessages (Name, Email, Subject, Message)
    VALUES (@Name, @Email, @Subject, @Message);
    SELECT SCOPE_IDENTITY() AS NewId;
END
GO

CREATE PROCEDURE sp_MarkMessageAsRead
    @Id int
AS
BEGIN
    UPDATE ContactMessages SET IsRead = 1 WHERE Id = @Id;
END
GO

CREATE PROCEDURE sp_DeleteContactMessage
    @Id int
AS
BEGIN
    DELETE FROM ContactMessages WHERE Id = @Id;
END
GO

-- Create Stored Procedure for Admin Authentication
CREATE PROCEDURE sp_ValidateAdminCredentials
    @Username nvarchar(50),
    @PasswordHash varbinary(32)
AS
BEGIN
    SELECT Id, Username
    FROM AdminUsers 
    WHERE Username = @Username AND PasswordHash = @PasswordHash;
    
    -- Update last login time
    UPDATE AdminUsers 
    SET LastLogin = GETDATE()
    WHERE Username = @Username AND PasswordHash = @PasswordHash;
END
GO

-- Create Dashboard Statistics Procedure
CREATE PROCEDURE sp_GetDashboardStats
AS
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM Projects WHERE IsActive = 1) as ActiveProjects,
        (SELECT COUNT(*) FROM Projects WHERE IsActive = 0) as InactiveProjects,
        (SELECT COUNT(*) FROM BlogPosts WHERE IsActive = 1) as ActiveBlogs,
        (SELECT COUNT(*) FROM BlogPosts WHERE IsActive = 0) as InactiveBlogs,
        (SELECT COUNT(*) FROM ContactMessages WHERE IsRead = 0) as UnreadMessages,
        (SELECT COUNT(*) FROM ContactMessages WHERE IsRead = 1) as ReadMessages;
END
GO

-- Insert seed data
-- Admin user: username = 'admin', password = 'portfolio2024' (SHA256 hashed)
INSERT INTO AdminUsers (Username, PasswordHash) 
VALUES ('admin', HASHBYTES('SHA2_256', 'portfolio2024'));

-- Sample Projects
INSERT INTO Projects (Title, Description, ImageUrl, ProjectUrl, TechStack, IsActive) VALUES
('E-Commerce Platform', 'Full-stack web application with secure payment integration, user authentication, and admin dashboard built with React and Node.js.', 'https://via.placeholder.com/400x300', 'https://github.com/IftiaqHossen/ecommerce', 'React, Node.js, MongoDB', 1),
('Portfolio Website', 'Responsive personal portfolio with modern animations and dark/light theme toggle.', 'https://via.placeholder.com/400x300', 'https://github.com/IftiaqHossen/portfolio', 'HTML/CSS, JavaScript', 1),
('Task Manager', 'Productivity app with drag-and-drop functionality and real-time updates.', 'https://via.placeholder.com/400x300', 'https://github.com/IftiaqHossen/task-manager', 'Vue.js, Firebase', 1),
('Weather App', 'Mobile-responsive weather application with location-based forecasts and beautiful UI.', 'https://via.placeholder.com/400x300', 'https://github.com/IftiaqHossen/weather-app', 'React Native, API Integration', 1),
('Blog Platform', 'Content management system with markdown support and user comments.', 'https://via.placeholder.com/400x300', 'https://github.com/IftiaqHossen/blog-platform', 'Next.js, MongoDB', 1);

-- Sample Blog Posts
INSERT INTO BlogPosts (Title, Slug, Description, Content, ImageUrl, Platform, IsActive) VALUES
('Understanding React Hooks: A Complete Guide', 'react-hooks-complete-guide', 'Deep dive into React Hooks, exploring useState, useEffect, and custom hooks with practical examples and best practices for modern React development.', '<p>React Hooks have revolutionized the way we write React components. In this comprehensive guide, we''ll explore the most commonly used hooks and how to create custom ones.</p><h3>useState Hook</h3><p>The useState hook allows you to add state to functional components...</p>', 'https://via.placeholder.com/400x200', 'Medium', 1),
('Building Secure REST APIs with Node.js', 'secure-rest-apis-nodejs', 'Learn how to implement authentication, authorization, input validation, and security best practices while building robust APIs with Express.js.', '<p>Security is paramount when building REST APIs. This article covers essential security practices for Node.js applications.</p><h3>Authentication Strategies</h3><p>We''ll explore JWT tokens, OAuth, and session-based authentication...</p>', 'https://via.placeholder.com/400x200', 'TechTune', 1),
('Python for Beginners: Data Structures and Algorithms', 'python-data-structures-algorithms', 'A comprehensive introduction to Python programming focusing on essential data structures, algorithms, and problem-solving techniques for competitive programming.', '<p>Python is an excellent language for learning data structures and algorithms. Let''s start with the basics.</p><h3>Lists and Arrays</h3><p>Understanding how to work with Python lists effectively...</p>', 'https://via.placeholder.com/400x200', 'Medium', 1),
('iOS Development with Swift: From Zero to App Store', 'ios-development-swift-guide', 'Complete guide to iOS development covering Swift fundamentals, UIKit, Core Data, and the app submission process with real-world project examples.', '<p>iOS development can seem daunting at first, but with the right approach, you can build amazing apps.</p><h3>Getting Started with Swift</h3><p>Swift is Apple''s powerful programming language...</p>', 'https://via.placeholder.com/400x200', 'TechTune', 1),
('Cybersecurity Fundamentals: Penetration Testing Basics', 'cybersecurity-penetration-testing-basics', 'Introduction to ethical hacking and penetration testing methodologies, tools, and techniques for identifying security vulnerabilities in web applications.', '<p>Penetration testing is a crucial aspect of cybersecurity. Learn the fundamentals of ethical hacking.</p><h3>Reconnaissance Phase</h3><p>The first step in penetration testing is gathering information...</p>', 'https://via.placeholder.com/400x200', 'Medium', 1),
('Modern Web Development: Full-Stack JavaScript', 'modern-web-development-fullstack-js', 'Explore the complete JavaScript ecosystem from frontend frameworks like React to backend development with Node.js, databases, and deployment strategies.', '<p>JavaScript has evolved from a simple scripting language to a full-stack development powerhouse.</p><h3>Frontend Development</h3><p>Modern frontend development with React, Vue, and Angular...</p>', 'https://via.placeholder.com/400x200', 'TechTune', 1);

PRINT 'PortfolioDB created successfully!';
PRINT 'Default admin credentials:';
PRINT 'Username: admin';
PRINT 'Password: portfolio2024';