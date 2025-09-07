using System;
using System.Web.UI;
using IftiCpy.Data;

namespace IftiCpy.Admin
{
    public partial class ManageBlog : Page
    {
        private PortfolioRepository _repository;
        private int? _blogId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["AdminUserId"] == null)
            {
                Response.Redirect("~/Admin/AdminLogin.aspx");
                return;
            }

            _repository = new PortfolioRepository();

            // Get blog ID from query string
            if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out int id))
            {
                _blogId = id;
            }

            if (!IsPostBack)
            {
                LoadBlogData();
            }
        }

        private void LoadBlogData()
        {
            if (_blogId.HasValue)
            {
                // Edit mode
                try
                {
                    var blog = _repository.GetBlogPostById(_blogId.Value);
                    if (blog != null)
                    {
                        PageTitle.Text = "Edit Blog Post";
                        btnSave.Text = "Update Blog Post";

                        // Populate form fields
                        txtTitle.Text = blog.Title;
                        txtSlug.Text = blog.Slug;
                        txtDescription.Text = blog.Description;
                        txtContent.Text = blog.Content;
                        txtImageUrl.Text = blog.ImageUrl ?? "";
                        chkIsActive.Checked = blog.IsActive;

                        // Set platform dropdown
                        if (!string.IsNullOrEmpty(blog.Platform))
                        {
                            var platformItem = ddlPlatform.Items.FindByValue(blog.Platform);
                            if (platformItem != null)
                            {
                                ddlPlatform.SelectedValue = blog.Platform;
                            }
                            else
                            {
                                // Custom platform
                                ddlPlatform.SelectedValue = "Other";
                                txtCustomPlatform.Text = blog.Platform;
                                
                                // Show custom platform row via client script
                                ClientScript.RegisterStartupScript(this.GetType(), "ShowCustomPlatform",
                                    "document.getElementById('customPlatformRow').style.display = 'block';", true);
                            }
                        }
                    }
                    else
                    {
                        ShowError("Blog post not found.");
                        return;
                    }
                }
                catch (Exception ex)
                {
                    ShowError("Error loading blog post data.");
                    System.Diagnostics.Debug.WriteLine("Error loading blog post: " + ex.Message);
                }
            }
            else
            {
                // Add mode
                PageTitle.Text = "Add New Blog Post";
                btnSave.Text = "Save Blog Post";
                chkIsActive.Checked = true; // Default to active
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            try
            {
                // Determine the platform value
                string platform = null;
                if (!string.IsNullOrEmpty(ddlPlatform.SelectedValue))
                {
                    if (ddlPlatform.SelectedValue == "Other")
                    {
                        platform = txtCustomPlatform.Text.Trim();
                    }
                    else
                    {
                        platform = ddlPlatform.SelectedValue;
                    }
                }

                var blogPost = new BlogPost
                {
                    Title = txtTitle.Text.Trim(),
                    Slug = txtSlug.Text.Trim(),
                    Description = txtDescription.Text.Trim(),
                    Content = txtContent.Text.Trim(),
                    ImageUrl = string.IsNullOrWhiteSpace(txtImageUrl.Text) ? null : txtImageUrl.Text.Trim(),
                    Platform = string.IsNullOrWhiteSpace(platform) ? null : platform,
                    IsActive = chkIsActive.Checked
                };

                // Generate slug if empty
                if (string.IsNullOrEmpty(blogPost.Slug))
                {
                    blogPost.GenerateSlug();
                }

                if (_blogId.HasValue)
                {
                    // Update existing blog post
                    blogPost.Id = _blogId.Value;
                    _repository.UpdateBlogPost(blogPost);
                    ShowSuccess("Blog post updated successfully!");
                }
                else
                {
                    // Create new blog post
                    var newId = _repository.InsertBlogPost(blogPost);
                    ShowSuccess("Blog post created successfully!");
                    
                    // Redirect to edit mode for the new blog post
                    Response.Redirect($"~/Admin/ManageBlog.aspx?id={newId}");
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while saving the blog post. Please try again.");
                System.Diagnostics.Debug.WriteLine("Error saving blog post: " + ex.Message);
            }
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/AdminPanel.aspx");
        }

        protected void BtnBackToPanel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/AdminPanel.aspx");
        }

        private void ShowSuccess(string message)
        {
            SuccessMessage.Text = message;
            SuccessPanel.Visible = true;
            ErrorPanel.Visible = false;
        }

        private void ShowError(string message)
        {
            ErrorMessage.Text = message;
            ErrorPanel.Visible = true;
            SuccessPanel.Visible = false;
        }
    }
}