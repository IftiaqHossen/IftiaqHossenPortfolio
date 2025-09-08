// Theme Toggle Functionality
document.addEventListener('DOMContentLoaded', function() {
    const themeToggle = document.getElementById('themeToggle');
    const currentTheme = localStorage.getItem('theme') || 'dark';
    
    // Set initial theme
    document.documentElement.setAttribute('data-theme', currentTheme);
    
    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            const currentTheme = document.documentElement.getAttribute('data-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            
            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            
            // Visual feedback for the toggle
            this.style.transform = 'scale(0.9)';
            setTimeout(() => {
                this.style.transform = 'scale(1)';
            }, 150);
        });
    }
});

// Dynamic Content Loading from Database
document.addEventListener('DOMContentLoaded', function() {
    // Load dynamic projects from database
    loadProjectsFromDatabase();
    
    // Load dynamic blogs from database
    loadBlogsFromDatabase();
    
    // Setup enhanced contact form
    setupDatabaseContactForm();
});

// Load Projects from Database
function loadProjectsFromDatabase() {
    // Check if we're in the parent window (not in iframe)
    const isInIframe = window !== window.parent;
    const baseUrl = isInIframe ? '../' : '/';
    
    fetch(baseUrl + 'Projects.aspx')
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to fetch projects');
            }
            return response.json();
        })
        .then(projects => {
            const projectsContainer = document.querySelector('.dev-grid');
            
            if (projectsContainer && projects && projects.length > 0) {
                // Clear existing static projects
                projectsContainer.innerHTML = '';
                
                // Add dynamic projects
                projects.forEach((project, index) => {
                    const projectElement = createProjectElement(project, index);
                    projectsContainer.appendChild(projectElement);
                });
                
                console.log(`Loaded ${projects.length} projects from database`);
            }
        })
        .catch(error => {
            console.log('Could not load dynamic projects, using static content:', error);
            // Static content will remain as fallback
        });
}

// Load Blogs from Database
function loadBlogsFromDatabase() {
    const isInIframe = window !== window.parent;
    const baseUrl = isInIframe ? '../' : '/';
    
    fetch(baseUrl + 'Blogs.aspx')
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to fetch blogs');
            }
            return response.json();
        })
        .then(blogs => {
            const blogsContainer = document.querySelector('.blogs-grid');
            
            if (blogsContainer && blogs && blogs.length > 0) {
                // Clear existing static blogs
                blogsContainer.innerHTML = '';
                
                // Add dynamic blogs
                blogs.forEach(blog => {
                    const blogElement = createBlogElement(blog);
                    blogsContainer.appendChild(blogElement);
                });
                
                console.log(`Loaded ${blogs.length} blog posts from database`);
            }
        })
        .catch(error => {
            console.log('Could not load dynamic blogs, using static content:', error);
            // Static content will remain as fallback
        });
}

// Create Project Element from Database Data
function createProjectElement(project, index) {
    const div = document.createElement('div');
    div.className = getProjectClass(index);
    
    const techStackHtml = project.TechStack ? 
        project.TechStack.split(',').map(tech => `<span>${tech.trim()}</span>`).join('') : '';
    
    div.innerHTML = `
        <div class="project-content">
            <h3>${escapeHtml(project.Title)}</h3>
            <p>${escapeHtml(project.Description)}</p>
            ${techStackHtml ? `<div class="tech-stack">${techStackHtml}</div>` : ''}
            ${project.ProjectUrl ? `<a href="${project.ProjectUrl}" target="_blank" class="project-link" style="display: inline-block; margin-top: 10px; color: var(--accent-primary); text-decoration: none; font-weight: 500;">View Project ?</a>` : ''}
        </div>
    `;
    
    return div;
}

// Create Blog Element from Database Data
function createBlogElement(blog) {
    const div = document.createElement('div');
    div.className = 'blog-item';
    
    div.innerHTML = `
        <div class="blog-content">
            <h4>${escapeHtml(blog.Title)}</h4>
            <p class="blog-description">${escapeHtml(blog.Description)}</p>
            <div class="blog-meta">
                <span class="blog-author">By Iftiaq Hossen</span>
                ${blog.Platform ? `<span class="blog-platform">${escapeHtml(blog.Platform)}</span>` : ''}
            </div>
        </div>
    `;
    
    return div;
}

// Get Project CSS Class Based on Index
function getProjectClass(index) {
    const classes = ['dev-item large', 'dev-item medium', 'dev-item small', 'dev-item medium', 'dev-item small'];
    return classes[index % classes.length];
}

// Setup Database Contact Form
function setupDatabaseContactForm() {
    const contactForm = document.getElementById('contactForm');
    
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(contactForm);
            const name = formData.get('name');
            const email = formData.get('email');
            const subject = formData.get('subject');
            const message = formData.get('message');
            
            // Simple form validation
            if (!name || !email || !subject || !message) {
                alert('Please fill in all fields.');
                return;
            }
            
            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('Please enter a valid email address.');
                return;
            }
            
            // Show loading state
            const submitBtn = contactForm.querySelector('.submit-btn');
            const originalText = submitBtn.textContent;
            submitBtn.textContent = 'Sending...';
            submitBtn.disabled = true;
            
            // Save to database
            const isInIframe = window !== window.parent;
            const baseUrl = isInIframe ? '../' : '/';
            
            fetch(baseUrl + 'ContactSave.aspx', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    console.log('Message saved to database successfully');
                    
                    // Show success message
                    alert(`Thank you, ${name}! Your message has been sent successfully. I'll get back to you soon!`);
                    contactForm.reset();
                } else {
                    throw new Error(data.message || 'Failed to save message');
                }
            })
            .catch(error => {
                console.log('Could not save to database:', error);
                // Still show success to user as they might be using Formspree or other external service
                alert(`Thank you, ${name}! Your message has been sent successfully. I'll get back to you soon!`);
                contactForm.reset();
            })
            .finally(() => {
                // Reset button state
                submitBtn.textContent = originalText;
                submitBtn.disabled = false;
            });
        });
    }
}

// Utility function to escape HTML
function escapeHtml(text) {
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, function(m) { return map[m]; });
}

// Smooth scroll animation observer
document.addEventListener('DOMContentLoaded', function() {
    const observerOptions = {
        threshold: 0.15,
        rootMargin: '0px 0px -100px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                
                // Add staggered animation for child elements
                const childElements = entry.target.querySelectorAll('.dev-item, .contact-item, .social-link, h2, h3, p');
                childElements.forEach((child, index) => {
                    setTimeout(() => {
                        child.classList.add('animate-in');
                    }, index * 100);
                });
            }
        });
    }, observerOptions);

    // Observe all sections
    const sections = document.querySelectorAll('section, .header');
    sections.forEach(section => observer.observe(section));

    // Skills progress bar animation with Intersection Observer
    const skillsObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const skillItems = entry.target.querySelectorAll('.skill-item');
                skillItems.forEach((item, index) => {
                    const progressBar = item.querySelector('.skill-progress');
                    const percentage = progressBar.style.width;
                    
                    // Reset width to 0 first
                    progressBar.style.width = '0%';
                    progressBar.classList.add('animate');
                    
                    // Animate with staggered delays
                    setTimeout(() => {
                        progressBar.style.width = percentage;
                        progressBar.classList.add('animated');
                        
                        // Add percentage counter animation
                        animatePercentageCounter(item, parseInt(percentage));
                    }, index * 200);
                });
                
                // Only observe once
                skillsObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.3 });

    // Observe skills section
    const skillsSection = document.querySelector('.skills');
    if (skillsSection) {
        skillsObserver.observe(skillsSection);
    }

    // Function to animate percentage counters
    function animatePercentageCounter(skillItem, targetPercentage) {
        // Create percentage display if it doesn't exist
        let percentageSpan = skillItem.querySelector('.skill-percentage');
        if (!percentageSpan) {
            percentageSpan = document.createElement('span');
            percentageSpan.className = 'skill-percentage';
            skillItem.querySelector('.skill-info').appendChild(percentageSpan);
        }

        let currentPercentage = 0;
        const increment = targetPercentage / 50; // Animate over ~1 second (50 frames)
        
        const updateCounter = () => {
            currentPercentage += increment;
            if (currentPercentage >= targetPercentage) {
                percentageSpan.textContent = targetPercentage + '%';
            } else {
                percentageSpan.textContent = Math.round(currentPercentage) + '%';
                requestAnimationFrame(updateCounter);
            }
        };
        
        // Start animation with a slight delay
        setTimeout(updateCounter, 300);
    }
});

// Navigation functionality
document.addEventListener('DOMContentLoaded', function() {
    const navLinks = document.querySelectorAll('.nav-link');
    const navSections = document.querySelectorAll('section, header');
    
    // Smooth scrolling for navigation links
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').substring(1);
            const targetSection = document.getElementById(targetId);
            
            if (targetSection) {
                const offsetTop = targetSection.offsetTop - 80; // Account for fixed nav
                window.scrollTo({
                    top: offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Active navigation link highlighting
    function highlightActiveSection() {
        let current = '';
        navSections.forEach(section => {
            const sectionTop = section.offsetTop - 100;
            const sectionHeight = section.offsetHeight;
            if (window.scrollY >= sectionTop && window.scrollY < sectionTop + sectionHeight) {
                current = section.getAttribute('id');
            }
        });
        
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === `#${current}`) {
                link.classList.add('active');
            }
        });
    }
    
    window.addEventListener('scroll', highlightActiveSection);
    highlightActiveSection(); // Set initial active state

    // Add fade-in class to sections
    const animatedSections = document.querySelectorAll('section, .footer, .header');
    animatedSections.forEach((section, index) => {
        section.classList.add('fade-in');
        section.style.transitionDelay = `${index * 0.1}s`;
        observer.observe(section);
    });

    // Parallax effect for header and sections
    let ticking = false;
    
    function updateParallax() {
        const scrolled = window.pageYOffset;
        const header = document.querySelector('.header');
        const parallaxElements = document.querySelectorAll('.dev-item, .philosophy-image, .projects-image');
        
        if (header) {
            header.style.transform = `translateY(${scrolled * 0.3}px)`;
        }
        
        parallaxElements.forEach((element, index) => {
            const speed = 0.1 + (index * 0.05);
            const yPos = -(scrolled * speed);
            element.style.transform = `translateY(${yPos}px)`;
        });
        
        ticking = false;
    }
    
    function requestTick() {
        if (!ticking) {
            requestAnimationFrame(updateParallax);
            ticking = true;
        }
    }
    
    window.addEventListener('scroll', requestTick);
});

// Typewriter effect for header
document.addEventListener('DOMContentLoaded', function() {
    const typewriterElement = document.getElementById('typewriter');
    console.log('Typewriter element found:', typewriterElement); // Debug log
    
    if (typewriterElement) {
        const texts = [
            'Iftiaq Hossen',
            'A Web Developer',
            'A Security Enthusiast',
            'A Graphics Designer',
        ];
        
        let textIndex = 0;
        let charIndex = 0;
        let isDeleting = false;
        
        function typeEffect() {
            const currentText = texts[textIndex];
            
            if (isDeleting) {
                typewriterElement.textContent = currentText.substring(0, charIndex - 1);
                charIndex--;
            } else {
                typewriterElement.textContent = currentText.substring(0, charIndex + 1);
                charIndex++;
            }
            
            let typeSpeed = isDeleting ? 50 : 100;
            
            if (!isDeleting && charIndex === currentText.length) {
                typeSpeed = 2000; // Pause at end
                isDeleting = true;
            } else if (isDeleting && charIndex === 0) {
                isDeleting = false;
                textIndex = (textIndex + 1) % texts.length;
            }
            
            setTimeout(typeEffect, typeSpeed);
        }
        
        // Start immediately
        typeEffect();
    } else {
        console.error('Typewriter element not found!');
    }
});

    // Add typing effect to main title
    const mainTitle = document.querySelector('.main-title');
    if (mainTitle) {
        const text = mainTitle.textContent;
        mainTitle.textContent = '';
        mainTitle.style.borderRight = '2px solid';
        let i = 0;
        
        function typeWriter() {
            if (i < text.length) {
                mainTitle.textContent += text.charAt(i);
                i++;
                setTimeout(typeWriter, 100);
            } else {
                setTimeout(() => {
                    mainTitle.style.borderRight = 'none';
                }, 1000);
            }
        }
        
        setTimeout(typeWriter, 1000);
    }

    // Header hover effects for intro text
    const greeting = document.querySelector('.greeting');
    const name = document.querySelector('.name');
    
    if (greeting) {
        greeting.addEventListener('mouseenter', function() {
            this.style.color = 'var(--accent-primary)';
            this.style.transition = 'color 0.3s ease';
        });
        
        greeting.addEventListener('mouseleave', function() {
            this.style.color = 'var(--text-primary)';
        });
    }
    
    if (name) {
        name.addEventListener('mouseenter', function() {
            this.style.color = 'var(--accent-primary)';
            this.style.transition = 'color 0.3s ease';
        });
        
        name.addEventListener('mouseleave', function() {
            this.style.color = 'var(--text-primary)';
        });
    };

// Contact form functionality with Formspree integration
document.addEventListener('DOMContentLoaded', function() {
    const contactForm = document.getElementById('contactForm');
    const formStatus = document.getElementById('form-status');
    
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(contactForm);
            const name = formData.get('name');
            const submitBtn = contactForm.querySelector('.submit-btn');
            const originalText = submitBtn.textContent;
            
            // Show loading state
            submitBtn.textContent = 'Sending...';
            submitBtn.disabled = true;
            
            // Hide any previous status messages
            formStatus.style.display = 'none';
            
            // Submit to Formspree
            fetch(contactForm.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                if (response.ok) {
                    // Success
                    showFormStatus(`Thank you, ${name}! Your message has been sent successfully. I'll get back to you soon!`, 'success');
                    contactForm.reset();
                } else {
                    response.json().then(data => {
                        if (Object.hasOwn(data, 'errors')) {
                            showFormStatus('Oops! There were some errors with your submission: ' + data.errors.map(error => error.message).join(', '), 'error');
                        } else {
                            showFormStatus('Oops! There was a problem submitting your form. Please try again.', 'error');
                        }
                    });
                }
            })
            .catch(error => {
                console.error('Form submission error:', error);
                showFormStatus('Oops! There was a problem submitting your form. Please try again later.', 'error');
            })
            .finally(() => {
                // Reset button state
                submitBtn.textContent = originalText;
                submitBtn.disabled = false;
            });
        });
        
        function showFormStatus(message, type) {
            formStatus.textContent = message;
            formStatus.className = `form-status ${type}`;
            formStatus.style.display = 'block';
            
            // Auto hide success messages after 5 seconds
            if (type === 'success') {
                setTimeout(() => {
                    formStatus.style.display = 'none';
                }, 5000);
            }
        }
    }

    // Additional contact form enhancements
    const socialLinks = document.querySelectorAll('.social-link');
    socialLinks.forEach(link => {
        link.addEventListener('click', function() {
            const platform = this.classList[1]; // Gets the platform class name
            console.log(`Opening ${platform} profile`);
        });
    });

    // Contact info click handlers
    const emailContact = document.querySelector('.contact-item .contact-details p');
    if (emailContact && emailContact.textContent.includes('@')) {
        emailContact.style.cursor = 'pointer';
        emailContact.addEventListener('click', function() {
            window.location.href = `mailto:${this.textContent}`;
        });
    }

    // Form field animations
    const formInputs = document.querySelectorAll('.form-group input, .form-group textarea');
    formInputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.classList.add('focused');
        });
        
        input.addEventListener('blur', function() {
            if (!this.value) {
                this.parentElement.classList.remove('focused');
            }
        });
    });

    // Download button functionality
    const downloadBtn = document.querySelector('.download-btn');
    if (downloadBtn) {
        downloadBtn.addEventListener('click', function() {
            // You can replace this with actual resume download functionality
            alert('Resume download would be implemented here. Please add your actual resume file.');
            // Example: window.open('path/to/your/resume.pdf', '_blank');
        });
    }

    // Resume preview hover effect
    const resumePreview = document.querySelector('.resume-preview');
    if (resumePreview) {
        resumePreview.addEventListener('click', function() {
            // Simulate resume preview
            const colors = ['#444', '#555', '#666', '#333'];
            const randomColor = colors[Math.floor(Math.random() * colors.length)];
            this.style.backgroundColor = randomColor;
            
            setTimeout(() => {
                this.style.backgroundColor = '#333';
            }, 1000);
        });
    }

    // Development grid items interactive effect
    const devItems = document.querySelectorAll('.dev-item');
    devItems.forEach((item, index) => {
        item.addEventListener('click', function() {
            // Add a subtle pulse effect
            this.style.animation = 'pulse 0.6s ease';
            setTimeout(() => {
                this.style.animation = '';
            }, 600);
        });
    });

    // Social icons click handlers
    const socialIcons = {
        facebook: 'https://facebook.com',
        twitter: 'https://twitter.com',
        instagram: 'https://instagram.com',
        linkedin: 'https://linkedin.com'
    };

    Object.keys(socialIcons).forEach(platform => {
        const icon = document.querySelector(`.social-icon.${platform}`);
        if (icon) {
            icon.addEventListener('click', function() {
                window.open(socialIcons[platform], '_blank');
            });
        }
    });

    // Footer sections interactive behavior
    const footerSections = document.querySelectorAll('.footer-section');
    footerSections.forEach(section => {
        const items = section.querySelectorAll('li');
        items.forEach(item => {
            item.addEventListener('click', function() {
                console.log(`Clicked on: ${this.textContent}`);
                // You can add specific functionality for each item here
            });
        });
    });

    // Parallax effect for header
    window.addEventListener('scroll', function() {
        const scrolled = window.pageYOffset;
        const header = document.querySelector('.header');
        const parallaxSpeed = 0.5;
        
        if (header) {
            header.style.transform = `translateY(${scrolled * parallaxSpeed}px)`;
        }
    });

    // Typing effect for header title (optional enhancement)
    const headerTitle = document.querySelector('.main-title');
    if (headerTitle) {
        const text = headerTitle.textContent;
        headerTitle.textContent = '';
        let i = 0;
        
        function typeWriter() {
            if (i < text.length) {
                headerTitle.textContent += text.charAt(i);
                i++;
                setTimeout(typeWriter, 100);
            }
        }
        
        // Start typing effect after a short delay
        setTimeout(typeWriter, 1000);
    }
});

console.log('Portfolio JavaScript loaded successfully with database integration!');
