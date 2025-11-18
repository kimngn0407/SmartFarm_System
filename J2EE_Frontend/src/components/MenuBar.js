/**
 * FILE: MenuBar.js
 * MỤC ĐÍCH: Component sidebar navigation chính của ứng dụng Smart Farm
 * Cung cấp menu navigation, user info và logout functionality
 */

// Import React hooks
import React, { useState, useEffect } from 'react';

// Import Material-UI components cho UI
import {
    Drawer,          // Sidebar container
    List,            // Menu list container
    ListItem,        // Individual menu items
    ListItemIcon,    // Icons cho menu items
    ListItemText,    // Text cho menu items
    Box,             // Layout container
    Typography,      // Text components
    IconButton,      // Clickable icon buttons
    useTheme,        // Hook để access theme
    useMediaQuery,   // Hook để responsive design
    Avatar,          // User avatar component
    Divider,         // Visual dividers
    Tooltip          // Tooltip cho UX
} from '@mui/material';

// Import icons cho menu items
import {
    Dashboard as DashboardIcon,          // Dashboard icon
    Agriculture as FarmIcon,             // Farm management icon
    Settings as SettingsIcon,            // Settings icon
    Logout as LogoutIcon,                // Logout icon
    ChevronLeft as ChevronLeftIcon,      // Collapse sidebar icon
    Menu as MenuIcon,                    // Mobile menu toggle icon
    Notifications as NotificationsIcon,   // Notifications icon (unused)
    Person as PersonIcon,                // Person/user icon
    ExpandLess,                          // Expand menu icon
    ExpandMore,                          // Collapse menu icon
    Map as FieldIcon,                    // Field management icon
    Spa as CropIcon,                     // Crop management icon
    BugReport as PestIcon,               // Pest detection icon
    Sensors as SensorIcon,               // Sensor management icon
    Warning as AlertIcon,                // Alert system icon
    MonetizationOn as RevenueIcon,       // Revenue management icon
    Opacity as WaterIcon,                // Irrigation system icon
    Lock as AuthIcon,                    // Authentication/account management icon
    AccountCircle as UserProfileIcon,    // User profile icon
} from '@mui/icons-material';

// Import Material-UI styling system
import { styled } from '@mui/material/styles';

// Import React Router hooks
import { useNavigate, useLocation } from 'react-router-dom';

// Import custom components và services
import RoleGuard from './Auth/RoleGuard';              // Component bảo vệ theo role
import accountService from '../services/accountService'; // Service quản lý account
import { getUserEmail, getUserRole } from '../services/authService'; // Auth utilities
import { clearUserData } from '../utils/clearOldData';  // Data cleanup utility

// Constants cho sidebar width
const drawerWidth = 280; // Pixel width của sidebar

/**
 * Styled Drawer Component - Sidebar container với custom styling
 * 
 * STYLING:
 * - Fixed width với drawerWidth constant
 * - Gradient background từ green tối đến green đậm (farm theme)
 * - White text color cho contrast
 * - Shadow effect để tạo depth
 */
const StyledDrawer = styled(Drawer)(({ theme }) => ({
    width: drawerWidth,          // Fixed width
    flexShrink: 0,              // Không shrink khi container nhỏ
    '& .MuiDrawer-paper': {     // Style cho Drawer paper element
        width: drawerWidth,
        boxSizing: 'border-box',
        // Green gradient background phù hợp với theme nông nghiệp
        background: 'linear-gradient(180deg,rgb(84, 94, 12) 0%,rgb(18, 67, 25) 100%)',
        color: 'white',          // White text
        borderRight: 'none',     // Remove default border
        boxShadow: '0 0 20px rgba(0,0,0,0.1)', // Subtle shadow
    },
}));

/**
 * Styled ListItem Component - Menu item với hover effects
 * 
 * FEATURES:
 * - Rounded corners cho modern look
 * - Hover animation với translateX effect
 * - Selected state styling
 * - Icon và text color consistency
 */
const StyledListItem = styled(ListItem)(({ theme }) => ({
    margin: '4px 0',            // Vertical spacing between items
    borderRadius: '8px',        // Rounded corners
    
    // Hover effects
    '&:hover': {
        backgroundColor: 'rgba(255, 255, 255, 0.1)', // Semi-transparent white overlay
        transform: 'translateX(5px)',                 // Slide right effect
        transition: 'all 0.3s ease',                 // Smooth transition
    },
    
    // Selected state styling
    '&.Mui-selected': {
        backgroundColor: 'rgba(255, 255, 255, 0.15)', // Lighter selected background
        '&:hover': {
            backgroundColor: 'rgba(255, 255, 255, 0.2)', // Even lighter on hover
        },
    },
    
    // Icon styling
    '& .MuiListItemIcon-root': {
        color: 'white',         // White icons
        minWidth: '40px',       // Consistent icon spacing
    },
    
    // Text styling
    '& .MuiListItemText-root': {
        '& .MuiTypography-root': {
            fontWeight: 500,    // Medium font weight
        },
    },
}));
/**
 * MenuBar Component - Main sidebar navigation
 * 
 * FEATURES:
 * - Responsive design (mobile/desktop)
 * - User info display với avatar
 * - Menu item navigation với selected state
 * - Role-based menu visibility
 * - Logout functionality
 * - Collapsible sidebar
 */
const MenuBar = () => {
    // Material-UI hooks cho responsive design
    const theme = useTheme();
    const isMobile = useMediaQuery(theme.breakpoints.down('sm')); // Check if screen < 600px
    
    // State management
    const [open, setOpen] = useState(!isMobile);        // Sidebar open/closed state (closed on mobile by default)
    const [selectedItem, setSelectedItem] = useState('dashboard'); // Currently selected menu item
    const [expandedGroups, setExpandedGroups] = useState({
        'quan-ly-nong-trai': true,
        'cay-trong-canh-tac': true,
        'he-thong': true,
    }); // Collapsible menu groups state
    
    // React Router hooks
    const navigate = useNavigate();  // Navigate function
    const location = useLocation();  // Current location/path
    
    // User info state
    const [userName, setUserName] = useState('');       // User's email/name
    const [userRole, setUserRole] = useState('');       // User's role (admin/user)

    /**
     * Menu Groups Configuration với collapsible
     */
    const menuGroups = [
        {
            id: 'quan-ly-nong-trai',
            title: 'Quản lý Nông trại',
            items: [
                { text: 'Farm Manager', icon: <FarmIcon />, path: '/farm', id: 'farm' },
                { text: 'Field Manager', icon: <FieldIcon />, path: '/field', id: 'field' },
                { text: 'Sensor Manager', icon: <SensorIcon />, path: '/sensor', id: 'sensor' },
                { text: 'Irrigation & Fertilization', icon: <WaterIcon />, path: '/irrigation', id: 'irrigation' },
            ]
        },
        {
            id: 'cay-trong-canh-tac',
            title: 'Cây trồng & Canh tác',
            items: [
                { text: 'Crop Manager', icon: <CropIcon />, path: '/crop', id: 'crop' },
                { text: 'Pest Detection', icon: <PestIcon />, path: '/pest-detection', id: 'pest-detection' },
                { text: 'Harvest & Revenue', icon: <RevenueIcon />, path: '/harvest', id: 'harvest' },
            ]
        },
        {
            id: 'he-thong',
            title: 'Hệ thống',
            items: [
                { text: 'Dashboard', icon: <DashboardIcon />, path: '/dashboard', id: 'dashboard' },
                { text: 'Alert Screen', icon: <AlertIcon />, path: '/alert', id: 'alert' },
                { text: 'User Profile', icon: <UserProfileIcon />, path: '/profile', id: 'profile' },
                { text: 'System Settings', icon: <SettingsIcon />, path: '/settings', id: 'settings' },
            ]
        },
    ];

    // Flatten menuGroups để tạo menuItems array
    const menuItems = menuGroups.flatMap(group => group.items);

    /**
     * useEffect - Handles route change và user data loading
     * 
     * CHỨC NĂNG:
     * 1. Update selected menu item based on current path
     * 2. Load user info từ localStorage/services
     * 3. Debug logging cho development
     */
    useEffect(() => {
        // 1. Update selected menu item dựa trên current path
        const currentPath = location.pathname;
        const matchedItem = menuItems.find(item => item.path === currentPath);
        if (matchedItem) {
            setSelectedItem(matchedItem.id);
        } else {
            setSelectedItem('dashboard'); // Default fallback
        }

        // 2. Fetch user information
        const fetchUser = async () => {
            try {
                // Debug logging để track localStorage state
                console.log('🔍 All localStorage keys:', Object.keys(localStorage));
                console.log('🔍 userEmail:', localStorage.getItem('userEmail'));
                console.log('🔍 userRole:', localStorage.getItem('userRole'));
                console.log('🔍 token:', localStorage.getItem('token'));
                
                // Kiểm tra authentication status
                if (!accountService.isLoggedIn()) {
                    setUserName('');
                    setUserRole('');
                    return;
                }

                // Lấy user data từ services/localStorage
                const storedEmail = accountService.getCurrentUserEmail();
                const storedRole = getUserRole();

                // Update state với user info
                if (storedEmail) {
                    setUserName(storedEmail);
                }
                
                if (storedRole) {
                    setUserRole(storedRole);
                }

                // Fallback: nếu chưa có role, thử lấy lại từ token
                if (!storedRole) {
                    const tokenRole = getUserRole();
                    if (tokenRole) {
                        setUserRole(tokenRole);
                    }
                }

                console.log('✅ User info loaded:', { email: storedEmail, role: storedRole });
            } catch (err) {
                console.error('❌ Error fetching user info:', err);
                // Reset user state nếu có lỗi
                setUserName('');
                setUserRole('');
            }
        };

        fetchUser();
    }, [location.pathname]); // Re-run khi route changes

    const handleGroupToggle = (groupId) => {
        setExpandedGroups(prev => ({
            ...prev,
            [groupId]: !prev[groupId]
        }));
    };

    /**
     * Toggle sidebar open/close state
     * Đặc biệt hữu ích cho mobile responsive
     */
    const handleDrawerToggle = () => {
        setOpen(!open);
    };

    /**
     * Handle menu item click
     * 
     * @param {string} path - Router path để navigate
     * @param {string} id - Menu item ID để update selected state
     */
    const handleItemClick = (path, id) => {
        setSelectedItem(id);        // Update selected item state
        navigate(path);             // Navigate to new route
        if (isMobile) {
            setOpen(false);         // Close sidebar on mobile after navigation
        }
    };

    /**
     * Handle user logout
     * 
     * PROCESS:
     * 1. Call accountService.logout() để clear token
     * 2. Clear additional user data từ localStorage
     * 3. Reset local state
     * 4. Navigate về login page
     */
    const handleLogout = () => {
        accountService.logout();    // Service method để clear token và user data
        clearUserData();           // Utility function để clear thêm data
        setUserName('');           // Reset local username state
        setUserRole('');           // Reset local user role state
        navigate('/login');        // Navigate về login page
    };

    return (
        <>
            {/* Mobile Menu Toggle Button - Chỉ hiện trên mobile */}
            {isMobile && (
                <IconButton
                    color="inherit"
                    aria-label="open drawer"    // Accessibility label
                    edge="start"               // Position at start of container
                    onClick={handleDrawerToggle}
                    sx={{
                        position: 'fixed',     // Fixed position overlay
                        left: 10,             // 10px from left edge
                        top: 10,              // 10px from top edge
                        zIndex: 1200,         // High z-index để luôn visible
                        backgroundColor: 'rgba(255, 255, 255, 0.1)', // Semi-transparent background
                        backdropFilter: 'blur(10px)',                // Blur effect
                        '&:hover': {
                            backgroundColor: 'rgba(255, 255, 255, 0.2)', // Lighter on hover
                        }
                    }}
                >
                    <MenuIcon />
                </IconButton>
            )}
            <StyledDrawer
                variant={isMobile ? 'temporary' : 'permanent'}
                open={open}
                onClose={handleDrawerToggle}
            >
                <Box sx={{
                    display: 'flex',
                    flexDirection: 'column',
                    height: '100%',
                    p: 2,
                }}>
                    <Box sx={{
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'space-between',
                        mb: 2,
                    }}>
                        <Box sx={{ display: 'flex', alignItems: 'center' }}>
                            <Avatar
                                sx={{
                                    width: 40,
                                    height: 40,
                                    mr: 1,
                                    backgroundColor: 'rgb(88, 61, 226)',
                                }}
                            >
                                <PersonIcon />
                            </Avatar>
                            <Box>
                                <Typography variant="h6" noWrap component="div" sx={{ fontWeight: 600 }}>
                                    {userName ? `Xin chào, ${userName}` : 'Xin chào'}
                                </Typography>
                                <Typography variant="body2" sx={{ color: '#fff', opacity: 0.8 }}>
                                    {userRole ? `(${userRole})` : ''}
                                </Typography>
                            </Box>
                        </Box>
                        {!isMobile && (
                            <Tooltip title="Thu gọn menu">
                                <IconButton
                                    onClick={handleDrawerToggle}
                                    sx={{
                                        color: 'white',
                                        '&:hover': {
                                            backgroundColor: 'rgba(255, 255, 255, 0.1)',
                                        }
                                    }}
                                >
                                    <ChevronLeftIcon />
                                </IconButton>
                            </Tooltip>
                        )}
                    </Box>

                    <Divider sx={{ borderColor: 'rgba(255, 255, 255, 0.1)', mb: 2 }} />

                    <List sx={{ flexGrow: 1 }}>
                        {menuGroups.map((group) => (
                            <React.Fragment key={group.id}>
                                {/* Group Header - Collapsible */}
                                <StyledListItem
                                    button
                                    onClick={() => handleGroupToggle(group.id)}
                                    sx={{
                                        backgroundColor: 'rgba(255, 255, 255, 0.05)',
                                        mb: 0.5,
                                        '&:hover': {
                                            backgroundColor: 'rgba(255, 255, 255, 0.1)',
                                        },
                                    }}
                                >
                                    <ListItemText 
                                        primary={
                                            <Typography variant="subtitle2" sx={{ fontWeight: 600, fontSize: '0.875rem' }}>
                                                {group.title}
                                            </Typography>
                                        }
                                    />
                                    <ListItemIcon sx={{ minWidth: 'auto', color: 'white' }}>
                                        {expandedGroups[group.id] ? <ExpandLess /> : <ExpandMore />}
                                    </ListItemIcon>
                                </StyledListItem>
                                
                                {/* Group Items - Collapsible */}
                                {expandedGroups[group.id] && (
                                    <Box
                                        sx={{
                                            maxHeight: expandedGroups[group.id] ? '1000px' : 0,
                                            overflow: 'hidden',
                                            transition: 'max-height 0.3s ease-in-out',
                                            ml: 2,
                                        }}
                                    >
                                        {group.items.map((item) => (
                                            <StyledListItem
                                                key={item.id}
                                                button
                                                onClick={() => handleItemClick(item.path, item.id)}
                                                selected={selectedItem === item.id}
                                                sx={{ pl: 3 }}
                                            >
                                                <ListItemIcon>{item.icon}</ListItemIcon>
                                                <ListItemText primary={item.text} />
                                            </StyledListItem>
                                        ))}
                                    </Box>
                                )}
                            </React.Fragment>
                        ))}
                    </List>

                    <Divider sx={{ borderColor: 'rgba(255, 255, 255, 0.1)', my: 2 }} />

                    <StyledListItem button onClick={handleLogout}>
                        <ListItemIcon><LogoutIcon /></ListItemIcon>
                        <ListItemText primary="Đăng xuất" />
                    </StyledListItem>
                </Box>
            </StyledDrawer>
        </>
    );
};

export default MenuBar;