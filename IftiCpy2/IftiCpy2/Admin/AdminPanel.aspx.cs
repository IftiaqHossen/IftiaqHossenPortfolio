using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using IftiCpy.Data;

namespace IftiCpy.Admin
{
    public partial class AdminPanel : Page
    {
        private PortfolioRepository _repository;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["AdminUserId"] == null)
            {
                Response.Redirect("~/Admin/AdminLogin.aspx");
                return;
            }

            _repository = new PortfolioRepository();

            if (!IsPostBack)
            {
                LoadDashboardData();
                LoadProjectsData();
                LoadBlogsData();
                LoadMessagesData();

                // Set welcome message
                WelcomeMessage.Text = Session["AdminUsername"]?.ToString() ?? "Admin";
            }
        }

        #region Dashboard Methods

        private void LoadDashboardData()
        {
            try
            {
                var stats = _repository.GetDashboardStats();
                ActiveProjectsCount.Text = stats.ActiveProjects.ToString();
                ActiveBlogsCount.Text = stats.ActiveBlogs.ToString();
                UnreadMessagesCount.Text = stats.UnreadMessages.ToString();
                TotalMessagesCount.Text = stats.TotalMessages.ToString();
            }
            catch (Exception ex)
            {
                // Log error in production
                System.Diagnostics.Debug.WriteLine("Error loading dashboard data: " + ex.Message);
            }
        }

        #endregion

        #region Projects Methods

        private void LoadProjectsData()
        {
            try
            {
                var projects = _repository.GetAllProjects();
                ProjectsGridView.DataSource = projects;
                ProjectsGridView.DataBind();
            }
            catch (Exception ex)
            {
                // Log error in production
                System.Diagnostics.Debug.WriteLine("Error loading projects: " + ex.Message);
            }
        }

        protected void BtnAddProject_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/ManageProject.aspx");
        }

        protected void ProjectsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int projectId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "EditProject":
                    Response.Redirect($"~/Admin/ManageProject.aspx?id={projectId}");
                    break;

                case "DeleteProject":
                    try
                    {
                        _repository.DeleteProject(projectId);
                        LoadProjectsData();
                        LoadDashboardData(); // Refresh dashboard stats
                    }
                    catch (Exception ex)
                    {
                        // Handle error - in production, show user-friendly message
                        System.Diagnostics.Debug.WriteLine("Error deleting project: " + ex.Message);
                    }
                    break;
            }
        }

        protected void ProjectsGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Additional row formatting if needed
        }

        #endregion

        #region Blog Posts Methods

        private void LoadBlogsData()
        {
            try
            {
                var blogs = _repository.GetAllBlogPosts();
                BlogsGridView.DataSource = blogs;
                BlogsGridView.DataBind();
            }
            catch (Exception ex)
            {
                // Log error in production
                System.Diagnostics.Debug.WriteLine("Error loading blogs: " + ex.Message);
            }
        }

        protected void BtnAddBlog_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/ManageBlog.aspx");
        }

        protected void BlogsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int blogId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "EditBlog":
                    Response.Redirect($"~/Admin/ManageBlog.aspx?id={blogId}");
                    break;

                case "DeleteBlog":
                    try
                    {
                        _repository.DeleteBlogPost(blogId);
                        LoadBlogsData();
                        LoadDashboardData(); // Refresh dashboard stats
                    }
                    catch (Exception ex)
                    {
                        // Handle error - in production, show user-friendly message
                        System.Diagnostics.Debug.WriteLine("Error deleting blog post: " + ex.Message);
                    }
                    break;
            }
        }

        protected void BlogsGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Additional row formatting if needed
        }

        #endregion

        #region Messages Methods

        private void LoadMessagesData()
        {
            try
            {
                var messages = _repository.GetAllContactMessages();
                MessagesGridView.DataSource = messages;
                MessagesGridView.DataBind();
            }
            catch (Exception ex)
            {
                // Log error in production
                System.Diagnostics.Debug.WriteLine("Error loading messages: " + ex.Message);
            }
        }

        protected void BtnRefreshMessages_Click(object sender, EventArgs e)
        {
            LoadMessagesData();
            LoadDashboardData(); // Refresh dashboard stats
        }

        protected void MessagesGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int messageId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "ViewMessage":
                    ShowMessageDetails(messageId);
                    break;

                case "MarkAsRead":
                    try
                    {
                        _repository.MarkMessageAsRead(messageId);
                        LoadMessagesData();
                        LoadDashboardData(); // Refresh dashboard stats
                    }
                    catch (Exception ex)
                    {
                        // Handle error
                        System.Diagnostics.Debug.WriteLine("Error marking message as read: " + ex.Message);
                    }
                    break;

                case "DeleteMessage":
                    try
                    {
                        _repository.DeleteContactMessage(messageId);
                        LoadMessagesData();
                        LoadDashboardData(); // Refresh dashboard stats
                    }
                    catch (Exception ex)
                    {
                        // Handle error
                        System.Diagnostics.Debug.WriteLine("Error deleting message: " + ex.Message);
                    }
                    break;
            }
        }

        protected void MessagesGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Additional row formatting if needed
        }

        private void ShowMessageDetails(int messageId)
        {
            try
            {
                // First, get all messages and find the one with matching ID
                var messages = _repository.GetAllContactMessages();
                var message = messages.Find(m => m.Id == messageId);

                if (message != null)
                {
                    ModalMessageName.Text = Server.HtmlEncode(message.Name);
                    ModalMessageEmail.Text = Server.HtmlEncode(message.Email);
                    ModalMessageSubject.Text = Server.HtmlEncode(message.Subject);
                    ModalMessageDate.Text = message.CreatedAt.ToString("MMMM dd, yyyy 'at' h:mm tt");
                    ModalMessageContent.Text = Server.HtmlEncode(message.Message).Replace("\n", "<br/>");

                    // Mark as read if not already read
                    if (!message.IsRead)
                    {
                        _repository.MarkMessageAsRead(messageId);
                        LoadMessagesData(); // Refresh the grid
                        LoadDashboardData(); // Refresh dashboard stats
                    }

                    // Show the modal using client script
                    ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showMessageModal();", true);
                }
            }
            catch (Exception ex)
            {
                // Handle error
                System.Diagnostics.Debug.WriteLine("Error showing message details: " + ex.Message);
            }
        }

        #endregion

        #region General Methods

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            // Clear session
            Session.Clear();
            Session.Abandon();

            // Redirect to login page
            Response.Redirect("~/Admin/AdminLogin.aspx");
        }

        #endregion
    }
}