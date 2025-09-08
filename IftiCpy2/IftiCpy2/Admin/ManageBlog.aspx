<%@ Page Title="Manage Blog Post" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageBlog.aspx.cs" Inherits="IftiCpy.Admin.ManageBlog" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-10 offset-md-1">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h4><asp:Literal ID="PageTitle" runat="server">Add New Blog Post</asp:Literal></h4>
                            <asp:LinkButton ID="btnBackToPanel" runat="server" Text="? Back to Admin Panel" 
                                CssClass="btn btn-outline-secondary" OnClick="BtnBackToPanel_Click" />
                        </div>
                    </div>
                    <div class="card-body">
                        <asp:Panel ID="SuccessPanel" runat="server" CssClass="alert alert-success" Visible="false">
                            <asp:Literal ID="SuccessMessage" runat="server"></asp:Literal>
                        </asp:Panel>

                        <asp:Panel ID="ErrorPanel" runat="server" CssClass="alert alert-danger" Visible="false">
                            <asp:Literal ID="ErrorMessage" runat="server"></asp:Literal>
                        </asp:Panel>

                        <div class="row">
                            <div class="col-md-8">
                                <div class="form-group mb-3">
                                    <label for="txtTitle" class="form-label">Blog Post Title <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" 
                                        placeholder="Enter blog post title" MaxLength="150" required></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" 
                                        ControlToValidate="txtTitle" ErrorMessage="Title is required." 
                                        CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group mb-3">
                                    <label for="txtSlug" class="form-label">URL Slug</label>
                                    <asp:TextBox ID="txtSlug" runat="server" CssClass="form-control" 
                                        placeholder="url-friendly-slug" MaxLength="150"></asp:TextBox>
                                    <div class="form-text">Leave empty to auto-generate from title</div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group mb-3">
                                    <label for="txtDescription" class="form-label">Short Description <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" 
                                        CssClass="form-control" placeholder="Brief description for blog listing" 
                                        MaxLength="300" required></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvDescription" runat="server" 
                                        ControlToValidate="txtDescription" ErrorMessage="Description is required." 
                                        CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="form-text">Maximum 300 characters - used in blog listings</div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group mb-3">
                                    <label for="txtContent" class="form-label">Full Content <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Rows="12" 
                                        CssClass="form-control" placeholder="Full blog post content (HTML allowed)" required></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvContent" runat="server" 
                                        ControlToValidate="txtContent" ErrorMessage="Content is required." 
                                        CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="form-text">HTML tags are allowed for formatting</div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label for="txtImageUrl" class="form-label">Featured Image URL</label>
                                    <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control" 
                                        placeholder="https://example.com/featured-image.jpg" MaxLength="255"></asp:TextBox>
                                    <div class="form-text">Optional: URL to featured image</div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group mb-3">
                                    <label for="txtPlatform" class="form-label">Platform</label>
                                    <asp:DropDownList ID="ddlPlatform" runat="server" CssClass="form-select">
                                        <asp:ListItem Value="">Select Platform</asp:ListItem>
                                        <asp:ListItem Value="Medium">Medium</asp:ListItem>
                                        <asp:ListItem Value="TechTune">TechTune</asp:ListItem>
                                        <asp:ListItem Value="Dev.to">Dev.to</asp:ListItem>
                                        <asp:ListItem Value="Personal Blog">Personal Blog</asp:ListItem>
                                        <asp:ListItem Value="Other">Other</asp:ListItem>
                                    </asp:DropDownList>
                                    <div class="form-text">Where the blog was published</div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group mb-3">
                                    <label class="form-label">Status</label>
                                    <div class="form-check">
                                        <asp:CheckBox ID="chkIsActive" runat="server" CssClass="form-check-input" Checked="true" />
                                        <label class="form-check-label">Active (visible on portfolio)</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Custom Platform Input (hidden by default) -->
                        <div class="row" id="customPlatformRow" style="display: none;">
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label for="txtCustomPlatform" class="form-label">Custom Platform Name</label>
                                    <asp:TextBox ID="txtCustomPlatform" runat="server" CssClass="form-control" 
                                        placeholder="Enter custom platform name" MaxLength="50"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <!-- Image Preview Section -->
                        <div class="row" id="imagePreviewSection" style="display: none;">
                            <div class="col-md-12">
                                <div class="form-group mb-3">
                                    <label class="form-label">Featured Image Preview</label>
                                    <div class="border rounded p-3 text-center bg-light">
                                        <img id="imagePreview" src="#" alt="Featured Image Preview" 
                                            class="img-fluid" style="max-height: 200px;" />
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Content Preview Section -->
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group mb-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <label class="form-label">Content Preview</label>
                                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="updatePreview()">
                                            Update Preview
                                        </button>
                                    </div>
                                    <div id="contentPreview" class="border rounded p-3 bg-light" style="min-height: 200px; max-height: 400px; overflow-y: auto;">
                                        <em class="text-muted">Content preview will appear here...</em>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group text-end">
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                                        CssClass="btn btn-secondary me-2" OnClick="BtnCancel_Click" CausesValidation="false" />
                                    <asp:Button ID="btnSave" runat="server" Text="Save Blog Post" 
                                        CssClass="btn btn-success" OnClick="BtnSave_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Auto-generate slug from title
        document.addEventListener('DOMContentLoaded', function() {
            const titleInput = document.getElementById('<%= txtTitle.ClientID %>');
            const slugInput = document.getElementById('<%= txtSlug.ClientID %>');
            const platformSelect = document.getElementById('<%= ddlPlatform.ClientID %>');
            const customPlatformRow = document.getElementById('customPlatformRow');
            const customPlatformInput = document.getElementById('<%= txtCustomPlatform.ClientID %>');
            const imageUrlInput = document.getElementById('<%= txtImageUrl.ClientID %>');

            // Auto-generate slug from title
            if (titleInput && slugInput) {
                titleInput.addEventListener('input', function() {
                    if (slugInput.value === '') {
                        const slug = this.value.toLowerCase()
                            .replace(/[^a-z0-9\s-]/g, '')
                            .replace(/\s+/g, '-')
                            .replace(/-+/g, '-')
                            .trim('-');
                        slugInput.value = slug;
                    }
                });
            }

            // Show/hide custom platform input
            if (platformSelect && customPlatformRow) {
                platformSelect.addEventListener('change', function() {
                    if (this.value === 'Other') {
                        customPlatformRow.style.display = 'block';
                    } else {
                        customPlatformRow.style.display = 'none';
                        customPlatformInput.value = '';
                    }
                });

                // Check initial state
                if (platformSelect.value === 'Other') {
                    customPlatformRow.style.display = 'block';
                }
            }

            // Image preview functionality
            if (imageUrlInput) {
                // Show preview on page load if URL exists
                if (imageUrlInput.value.trim() !== '') {
                    showImagePreview(imageUrlInput.value);
                }

                // Show preview on input change
                imageUrlInput.addEventListener('input', function() {
                    const url = this.value.trim();
                    if (url !== '' && isValidImageUrl(url)) {
                        showImagePreview(url);
                    } else {
                        hideImagePreview();
                    }
                });
            }

            // Initial content preview
            updatePreview();
        });

        function showImagePreview(url) {
            const imagePreview = document.getElementById('imagePreview');
            const previewSection = document.getElementById('imagePreviewSection');
            
            imagePreview.src = url;
            imagePreview.onload = function() {
                previewSection.style.display = 'block';
            };
            imagePreview.onerror = function() {
                hideImagePreview();
            };
        }

        function hideImagePreview() {
            document.getElementById('imagePreviewSection').style.display = 'none';
            document.getElementById('imagePreview').src = '#';
        }

        function isValidImageUrl(url) {
            return /\.(jpg|jpeg|png|gif|bmp|webp|svg)(\?.*)?$/i.test(url) || url.includes('placeholder');
        }

        function updatePreview() {
            const contentInput = document.getElementById('<%= txtContent.ClientID %>');
            const preview = document.getElementById('contentPreview');
            
            if (contentInput.value.trim() === '') {
                preview.innerHTML = '<em class="text-muted">Content preview will appear here...</em>';
            } else {
                preview.innerHTML = contentInput.value;
            }
        }

        // Character counters
        document.addEventListener('DOMContentLoaded', function() {
            addCharacterCounter('<%= txtDescription.ClientID %>', 300);
        });

        function addCharacterCounter(inputId, maxLength) {
            const input = document.getElementById(inputId);
            if (input) {
                const counterDiv = document.createElement('div');
                counterDiv.className = 'form-text text-end';
                input.parentNode.appendChild(counterDiv);
                
                function updateCounter() {
                    const remaining = maxLength - input.value.length;
                    counterDiv.textContent = `${remaining} characters remaining`;
                    counterDiv.className = remaining < 50 ? 'form-text text-end text-warning' : 'form-text text-end text-muted';
                }
                
                updateCounter();
                input.addEventListener('input', updateCounter);
            }
        }
    </script>

    <style>
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .form-label {
            font-weight: 500;
        }
        .text-danger {
            font-size: 0.875em;
        }
        #imagePreview {
            border-radius: 8px;
        }
        #contentPreview {
            font-family: Georgia, serif;
            line-height: 1.6;
        }
        #contentPreview h1, #contentPreview h2, #contentPreview h3 {
            margin-top: 1.5rem;
            margin-bottom: 0.5rem;
        }
        #contentPreview p {
            margin-bottom: 1rem;
        }
        .btn-success {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-success:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
        }
        .form-select {
            border-radius: 0.375rem;
        }
    </style>
</asp:Content>