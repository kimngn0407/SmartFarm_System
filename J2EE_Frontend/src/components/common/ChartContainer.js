import React from 'react';
import { Paper, Box, Typography } from '@mui/material';

/**
 * ChartContainer Component - Wrapper cho charts với responsive
 */
const ChartContainer = ({ title, children, height = 350, sx = {} }) => {
  return (
    <Paper
      sx={{
        p: 3,
        height: { xs: 'auto', md: height },
        minHeight: { xs: 300, md: height },
        display: 'flex',
        flexDirection: 'column',
        borderRadius: 2,
        boxShadow: 2,
        transition: 'all 0.3s ease',
        '&:hover': {
          boxShadow: 4,
        },
        ...sx,
      }}
    >
      {title && (
        typeof title === 'string' ? (
          <Typography
            variant="h6"
            gutterBottom
            fontWeight="bold"
            sx={{ mb: 2, fontSize: { xs: '1rem', md: '1.25rem' } }}
          >
            {title}
          </Typography>
        ) : (
          <Box sx={{ mb: 2 }}>
            {title}
          </Box>
        )
      )}
      <Box
        sx={{
          flex: 1,
          width: '100%',
          position: 'relative',
          minHeight: { xs: 250, md: height - 100 },
        }}
      >
        {children}
      </Box>
    </Paper>
  );
};

export default ChartContainer;





