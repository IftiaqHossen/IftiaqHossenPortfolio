using System;
using System.Web.UI;
using IftiCpy.Data;

namespace IftiCpy.Admin
{
    public partial class AdminLogin : Page
    {
        private PortfolioRepository _repository;

        protected void Page_Load(object sender, EventArgs e)
        {
            _repository = new PortfolioRepository();

            // If already logged in, redirect to admin panel
            if (Session["AdminUserId"] != null)
            {
                Response.Redirect("~/Admin/AdminPanel.aspx");
            }
        }

        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                string username = txtUsername.Text.Trim();
                string password = txtPassword.Text.Trim();

                if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
                {
                    ShowError("Please enter both username and password.");
                    return;
                }

                var adminUser = _repository.ValidateAdminCredentials(username, password);
                
                if (adminUser != null)
                {
                    // Successful login - set session
                    Session["AdminUserId"] = adminUser.Id;
                    Session["AdminUsername"] = adminUser.Username;
                    Session.Timeout = 30; // 30 minutes

                    // Redirect to admin panel
                    Response.Redirect("~/Admin/AdminPanel.aspx");
                }
                else
                {
                    ShowError("Invalid username or password.");
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred during login. Please try again.");
                // In production, log the actual error: System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }

        private void ShowError(string message)
        {
            ErrorMessage.Text = message;
            ErrorPanel.Visible = true;
        }
    }
}