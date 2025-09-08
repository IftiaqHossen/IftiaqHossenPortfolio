<%@ Page Title="Admin Panel" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminPanel.aspx.cs" Inherits="IftiCpy.Admin.AdminPanel" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Admin Dashboard</h2>
                    <div>
                        <span class="text-muted">Welcome, </span>
                        <strong><asp:Literal ID="WelcomeMessage" runat="server"></asp:Literal></strong>
                        <asp:LinkButton ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-outline-secondary btn-sm ms-3" OnClick="BtnLogout_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabs Navigation -->
        <ul class="nav nav-tabs" id="adminTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="dashboard-tab" data-bs-toggle="tab" data-bs-target="#dashboard" type="button" role="tab">
                    Dashboard
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="projects-tab" data-bs-toggle="tab" data-bs-target="#projects" type="button" role="tab">
                    Projects
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="blogs-tab" data-bs-toggle="tab" data-bs-target="#blogs" type="button" role="tab">
                    Blog Posts
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="messages-tab" data-bs-toggle="tab" data-bs-target="#messages" type="button" role="tab">
                    Messages
                </button>
            </li>
        </ul>

        <!-- Tab Content -->
        <div class="tab-content mt-4" id="adminTabsContent">
            <!-- Dashboard Tab -->
            <div class="tab-pane fade show active" id="dashboard" role="tabpanel">
                <div class="row">
                    <div class="col-md-3">
                        <div class="card text-white bg-primary mb-3">
                            <div class="card-body">
                                <h5 class="card-title">Active Projects</h5>
                                <h3><asp:Literal ID="ActiveProjectsCount" runat="server">0</asp:Literal></h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-white bg-success mb-3">
                            <div class="card-body">
                                <h5 class="card-title">Active Blogs</h5>
                                <h3><asp:Literal ID="ActiveBlogsCount" runat="server">0</asp:Literal></h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-white bg-warning mb-3">
                            <div class="card-body">
                                <h5 class="card-title">Unread Messages</h5>
                                <h3><asp:Literal ID="UnreadMessagesCount" runat="server">0</asp:Literal></h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-white bg-info mb-3">
                            <div class="card-body">
                                <h5 class="card-title">Total Messages</h5>
                                <h3><asp:Literal ID="TotalMessagesCount" runat="server">0</asp:Literal></h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Projects Tab -->
            <div class="tab-pane fade" id="projects" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4>Manage Projects</h4>
                    <asp:Button ID="btnAddProject" runat="server" Text="Add New Project" CssClass="btn btn-success" OnClick="BtnAddProject_Click" />
                </div>

                <asp:GridView ID="ProjectsGridView" runat="server" CssClass="table table-striped table-hover" 
                    AutoGenerateColumns="false" DataKeyNames="Id" OnRowCommand="ProjectsGridView_RowCommand" 
                    OnRowDataBound="ProjectsGridView_RowDataBound" EmptyDataText="No projects found.">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="50px" />
                        <asp:BoundField DataField="Title" HeaderText="Title" ItemStyle-Width="200px" />
                        <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-Width="300px" />
                        <asp:TemplateField HeaderText="Status" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <asp:Label ID="lblStatus" runat="server" 
                                    Text='<%# (bool)Eval("IsActive") ? "Active" : "Inactive" %>'
                                    CssClass='<%# (bool)Eval("IsActive") ? "badge bg-success" : "badge bg-secondary" %>'>
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CreatedAt" HeaderText="Created" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-Width="100px" />
                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="150px">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditProject" runat="server" CommandName="EditProject" 
                                    CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-primary me-1">Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteProject" runat="server" CommandName="DeleteProject" 
                                    CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-danger"
                                    OnClientClick="return confirm('Are you sure you want to delete this project?');">Delete</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <!-- Blog Posts Tab -->
            <div class="tab-pane fade" id="blogs" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4>Manage Blog Posts</h4>
                    <asp:Button ID="btnAddBlog" runat="server" Text="Add New Blog Post" CssClass="btn btn-success" OnClick="BtnAddBlog_Click" />
                </div>

                <asp:GridView ID="BlogsGridView" runat="server" CssClass="table table-striped table-hover" 
                    AutoGenerateColumns="false" DataKeyNames="Id" OnRowCommand="BlogsGridView_RowCommand"
                    OnRowDataBound="BlogsGridView_RowDataBound" EmptyDataText="No blog posts found.">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="50px" />
                        <asp:BoundField DataField="Title" HeaderText="Title" ItemStyle-Width="200px" />
                        <asp:BoundField DataField="Platform" HeaderText="Platform" ItemStyle-Width="100px" />
                        <asp:TemplateField HeaderText="Status" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <asp:Label ID="lblBlogStatus" runat="server" 
                                    Text='<%# (bool)Eval("IsActive") ? "Active" : "Inactive" %>'
                                    CssClass='<%# (bool)Eval("IsActive") ? "badge bg-success" : "badge bg-secondary" %>'>
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CreatedAt" HeaderText="Created" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-Width="100px" />
                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="150px">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditBlog" runat="server" CommandName="EditBlog" 
                                    CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-primary me-1">Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteBlog" runat="server" CommandName="DeleteBlog" 
                                    CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-danger"
                                    OnClientClick="return confirm('Are you sure you want to delete this blog post?');">Delete</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <!-- Messages Tab -->
            <div class="tab-pane fade" id="messages" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4>Contact Messages</h4>
                    <asp:Button ID="btnRefreshMessages" runat="server" Text="Refresh" CssClass="btn btn-primary" OnClick="BtnRefreshMessages_Click" />
                </div>

                <asp:GridView ID="MessagesGridView" runat="server" CssClass="table table-striped table-hover" 
                    AutoGenerateColumns="false" DataKeyNames="Id" OnRowCommand="MessagesGridView_RowCommand"
                    OnRowDataBound="MessagesGridView_RowDataBound" EmptyDataText="No messages found.">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="50px" />
                        <asp:BoundField DataField="Name" HeaderText="Name" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="Email" HeaderText="Email" ItemStyle-Width="200px" />
                        <asp:BoundField DataField="Subject" HeaderText="Subject" ItemStyle-Width="200px" />
                        <asp:TemplateField HeaderText="Status" ItemStyle-Width="80px">
                            <ItemTemplate>
                                <asp:Label ID="lblMessageStatus" runat="server" 
                                    Text='<%# !(bool)Eval("IsRead") ? "New" : "Read" %>'
                                    CssClass='<%# !(bool)Eval("IsRead") ? "badge bg-warning text-dark" : "badge bg-secondary" %>'>
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CreatedAt" HeaderText="Received" DataFormatString="{0:MM/dd/yyyy HH:mm}" ItemStyle-Width="120px" />
                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="200px">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnViewMessage" runat="server" CommandName="ViewMessage" 
                                    CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-info me-1">View</asp:LinkButton>
                                <asp:LinkButton ID="btnMarkAsRead" runat="server" CommandName="MarkAsRead" 
                                    CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-secondary me-1"
                                    Visible='<%# !(bool)Eval("IsRead") %>'>Mark Read</asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteMessage" runat="server" CommandName="DeleteMessage" 
                                    CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-danger"
                                    OnClientClick="return confirm('Are you sure you want to delete this message?');">Delete</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- Message View Modal -->
    <div class="modal fade" id="messageModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Message Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-sm-3"><strong>From:</strong></div>
                        <div class="col-sm-9"><asp:Literal ID="ModalMessageName" runat="server"></asp:Literal></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-3"><strong>Email:</strong></div>
                        <div class="col-sm-9"><asp:Literal ID="ModalMessageEmail" runat="server"></asp:Literal></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-3"><strong>Subject:</strong></div>
                        <div class="col-sm-9"><asp:Literal ID="ModalMessageSubject" runat="server"></asp:Literal></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-3"><strong>Received:</strong></div>
                        <div class="col-sm-9"><asp:Literal ID="ModalMessageDate" runat="server"></asp:Literal></div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3"><strong>Message:</strong></div>
                        <div class="col-sm-9"><asp:Literal ID="ModalMessageContent" runat="server"></asp:Literal></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <style>
        .nav-tabs .nav-link.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: #667eea;
        }
        .nav-tabs .nav-link {
            border: 1px solid #dee2e6;
            margin-right: 5px;
        }
        .nav-tabs .nav-link:hover {
            background-color: #f8f9fa;
        }
        .table th {
            background-color: #f8f9fa;
            border-top: none;
        }
        .badge {
            font-size: 0.75em;
        }
    </style>

    <script>
        function showMessageModal() {
            var messageModal = new bootstrap.Modal(document.getElementById('messageModal'));
            messageModal.show();
        }
    </script>
</asp:Content>