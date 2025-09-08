<%@ Page Title="Manage Project" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageProject.aspx.cs" Inherits="IftiCpy.Admin.ManageProject" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h4><asp:Literal ID="PageTitle" runat="server">Add New Project</asp:Literal></h4>
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
                            <div class="col-md-12">
                                <div class="form-group mb-3">
                                    <label for="txtTitle" class="form-label">Project Title <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" 
                                        placeholder="Enter project title" MaxLength="100" required></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" 
                                        ControlToValidate="txtTitle" ErrorMessage="Title is required." 
                                        CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group mb-3">
                                    <label for="txtDescription" class="form-label">Description <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" 
                                        CssClass="form-control" placeholder="Enter project description" 
                                        MaxLength="500" required></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvDescription" runat="server" 
                                        ControlToValidate="txtDescription" ErrorMessage="Description is required." 
                                        CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="form-text">Maximum 500 characters</div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label for="txtImageUrl" class="form-label">Image URL</label>
                                    <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control" 
                                        placeholder="https://example.com/image.jpg" MaxLength="255"></asp:TextBox>
                                    <div class="form-text">Optional: URL to project screenshot or logo</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label for="txtProjectUrl" class="form-label">Project URL</label>
                                    <asp:TextBox ID="txtProjectUrl" runat="server" CssClass="form-control" 
                                        placeholder="https://github.com/username/project" MaxLength="255"></asp:TextBox>
                                    <div class="form-text">Optional: Link to live demo or repository</div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-8">
                                <div class="form-group mb-3">
                                    <label for="txtTechStack" class="form-label">Technology Stack</label>
                                    <asp:TextBox ID="txtTechStack" runat="server" CssClass="form-control" 
                                        placeholder="React, Node.js, MongoDB" MaxLength="200"></asp:TextBox>
                                    <div class="form-text">Optional: Comma-separated list of technologies used</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group mb-3">
                                    <label class="form-label">Status</label>
                                    <div class="form-check">
                                        <asp:CheckBox ID="chkIsActive" runat="server" CssClass="form-check-input" Checked="true" />
                                        <label class="form-check-label">Active (visible on portfolio)</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Image Preview Section -->
                        <div class="row" id="imagePreviewSection" style="display: none;">
                            <div class="col-md-12">
                                <div class="form-group mb-3">
                                    <label class="form-label">Image Preview</label>
                                    <div class="border rounded p-3 text-center bg-light">
                                        <img id="imagePreview" src="#" alt="Project Image Preview" 
                                            class="img-fluid" style="max-height: 200px;" />
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group text-end">
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                                        CssClass="btn btn-secondary me-2" OnClick="BtnCancel_Click" CausesValidation="false" />
                                    <asp:Button ID="btnSave" runat="server" Text="Save Project" 
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
        // Image preview functionality
        document.addEventListener('DOMContentLoaded', function() {
            const imageUrlInput = document.getElementById('<%= txtImageUrl.ClientID %>');
            const imagePreview = document.getElementById('imagePreview');
            const previewSection = document.getElementById('imagePreviewSection');

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

            function showImagePreview(url) {
                imagePreview.src = url;
                imagePreview.onload = function() {
                    previewSection.style.display = 'block';
                };
                imagePreview.onerror = function() {
                    hideImagePreview();
                };
            }

            function hideImagePreview() {
                previewSection.style.display = 'none';
                imagePreview.src = '#';
            }

            function isValidImageUrl(url) {
                return /\.(jpg|jpeg|png|gif|bmp|webp|svg)(\?.*)?$/i.test(url) || url.includes('placeholder');
            }
        });

        // Character count for description
        document.addEventListener('DOMContentLoaded', function() {
            const descriptionInput = document.getElementById('<%= txtDescription.ClientID %>');
            if (descriptionInput) {
                const maxLength = 500;
                
                // Create character counter
                const counterDiv = document.createElement('div');
                counterDiv.className = 'form-text text-end';
                counterDiv.id = 'charCounter';
                descriptionInput.parentNode.appendChild(counterDiv);
                
                function updateCounter() {
                    const remaining = maxLength - descriptionInput.value.length;
                    counterDiv.textContent = `${remaining} characters remaining`;
                    counterDiv.className = remaining < 50 ? 'form-text text-end text-warning' : 'form-text text-end text-muted';
                }
                
                updateCounter();
                descriptionInput.addEventListener('input', updateCounter);
            }
        });
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
        .btn-success {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-success:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
        }
    </style>
</asp:Content>