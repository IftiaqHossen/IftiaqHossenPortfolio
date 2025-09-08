using System;
using System.Web.UI;
using System.IO;
using Newtonsoft.Json;
using IftiCpy.Data;

namespace IftiCpy
{
    public partial class ContactSave : Page
    {
        private PortfolioRepository _repository;

        protected void Page_Load(object sender, EventArgs e)
        {
            _repository = new PortfolioRepository();

            // Set response type to JSON
            Response.ContentType = "application/json";

            try
            {
                if (Request.HttpMethod == "POST")
                {
                    ProcessContactForm();
                }
                else
                {
                    Response.StatusCode = 405; // Method Not Allowed
                    Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Only POST method is allowed." }));
                }
            }
            catch (Exception ex)
            {
                Response.StatusCode = 500;
                Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Internal server error." }));
                System.Diagnostics.Debug.WriteLine("ContactSave error: " + ex.Message);
            }

            Response.End();
        }

        private void ProcessContactForm()
        {
            string name = null;
            string email = null;
            string subject = null;
            string message = null;

            // Try to get data from form fields first (direct POST)
            name = Request.Form["name"];
            email = Request.Form["email"];
            subject = Request.Form["subject"];
            message = Request.Form["message"];

            // If form fields are empty, try to parse JSON body (webhook)
            if (string.IsNullOrEmpty(name))
            {
                try
                {
                    using (var reader = new StreamReader(Request.InputStream))
                    {
                        string json = reader.ReadToEnd();
                        var data = JsonConvert.DeserializeObject<dynamic>(json);
                        
                        name = data?.name?.ToString();
                        email = data?.email?.ToString();
                        subject = data?.subject?.ToString();
                        message = data?.message?.ToString();
                    }
                }
                catch
                {
                    // Ignore JSON parsing errors, fall back to form data
                }
            }

            // Validate required fields
            if (string.IsNullOrWhiteSpace(name) || string.IsNullOrWhiteSpace(email) || 
                string.IsNullOrWhiteSpace(subject) || string.IsNullOrWhiteSpace(message))
            {
                Response.StatusCode = 400;
                Response.Write(JsonConvert.SerializeObject(new 
                { 
                    success = false, 
                    message = "All fields are required: name, email, subject, message" 
                }));
                return;
            }

            // Basic email validation
            if (!IsValidEmail(email))
            {
                Response.StatusCode = 400;
                Response.Write(JsonConvert.SerializeObject(new 
                { 
                    success = false, 
                    message = "Invalid email address format" 
                }));
                return;
            }

            // Save to database
            try
            {
                var contactMessage = new ContactMessage
                {
                    Name = name.Trim(),
                    Email = email.Trim().ToLower(),
                    Subject = subject.Trim(),
                    Message = message.Trim()
                };

                var newId = _repository.InsertContactMessage(contactMessage);

                Response.Write(JsonConvert.SerializeObject(new 
                { 
                    success = true, 
                    message = "Message saved successfully",
                    id = newId
                }));
            }
            catch (Exception ex)
            {
                Response.StatusCode = 500;
                Response.Write(JsonConvert.SerializeObject(new 
                { 
                    success = false, 
                    message = "Failed to save message to database" 
                }));
                System.Diagnostics.Debug.WriteLine("Database save error: " + ex.Message);
            }
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }
    }
}