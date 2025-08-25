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
            this.style.color = '#ffcc00';
            this.style.transition = 'color 0.3s ease';
        });
        
        greeting.addEventListener('mouseleave', function() {
            this.style.color = '#ffffff';
        });
    }
    
    if (name) {
        name.addEventListener('mouseenter', function() {
            this.style.color = '#ffffff';
            this.style.transition = 'color 0.3s ease';
        });
        
        name.addEventListener('mouseleave', function() {
            this.style.color = '#cccccc';
        });
    }

        });

    // Contact form functionality
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
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
            
            // Simulate form submission
            const submitBtn = contactForm.querySelector('.submit-btn');
            const originalText = submitBtn.textContent;
            submitBtn.textContent = 'Sending...';
            submitBtn.disabled = true;
            
            // Simulate API call
            setTimeout(() => {
                alert(`Thank you, ${name}! Your message has been sent successfully. I'll get back to you soon!`);
                contactForm.reset();
                submitBtn.textContent = originalText;
                submitBtn.disabled = false;
            }, 1500);
        });
    }

    // Social links click tracking
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
    });

// Contact form functionality
document.addEventListener('DOMContentLoaded', function() {
    const contactForm = document.getElementById('contactForm');
    
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;
            const message = document.getElementById('message').value;
            
            if (name && email && message) {
                alert('Thank you for your message! I will get back to you soon.');
                contactForm.reset();
            } else {
                alert('Please fill in all fields.');
            }
        });
    }
});

// Animated Text Functionality for Resume Section
document.addEventListener('DOMContentLoaded', function() {
    const animatedTextElements = document.querySelectorAll('.animated-title, .animated-text');
    
    // Create intersection observer for text animations
    const textObserver = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const words = entry.target.querySelectorAll('.word');
                const progress = entry.intersectionRatio;
                animateWords(words, progress);
            }
        });
    }, {
        threshold: Array.from({length: 21}, (_, i) => i / 20), // Create thresholds from 0 to 1
        rootMargin: '-20% 0px -30% 0px'
    });

    // Observe animated text elements
    animatedTextElements.forEach(element => {
        textObserver.observe(element);
    });

    // Function to animate words based on scroll progress
    function animateWords(words, progress) {
        const adjustedProgress = Math.max(0, Math.min(1, (progress - 0.2) * 1.5)); // Start animation after 20% visibility
        const wordsToAnimate = Math.floor(words.length * adjustedProgress);
        
        words.forEach((word, index) => {
            if (index < wordsToAnimate) {
                word.classList.add('active');
            } else {
                word.classList.remove('active');
            }
        });
    }
});

// Arrow click functionality for Resume section
document.addEventListener('DOMContentLoaded', function() {
    const arrowIndicator = document.querySelector('.arrow-indicator');
    
    if (arrowIndicator) {
        arrowIndicator.addEventListener('click', function() {
            const resumeSection = document.querySelector('.resume');
            if (resumeSection) {
                const offsetTop = resumeSection.offsetTop - 80; // Account for fixed nav
                window.scrollTo({
                    top: offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    }
});

console.log('Portfolio JavaScript loaded successfully!');
