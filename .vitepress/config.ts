import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'F7 Trust Center',
  description: 'Security, privacy, and compliance documentation for the F7 AI Workforce Intelligence Platform.',
  srcDir: 'content',
  base: '/public-docs/',
  cleanUrls: true,
  lastUpdated: true,

  head: [
    ['meta', { name: 'theme-color', content: '#1a56db' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:title', content: 'F7 Trust Center' }],
    ['meta', { property: 'og:description', content: 'Security, privacy, and compliance documentation for the F7 platform.' }],
    ['meta', { property: 'og:url', content: 'https://f7-platform.github.io/public-docs/' }],
  ],

  themeConfig: {
    siteTitle: 'F7 Trust Center',

    nav: [
      { text: 'Overview', link: '/overview/what-is-f7' },
      { text: 'Security', link: '/security/' },
      { text: 'Privacy', link: '/privacy/' },
      { text: 'Compliance', link: '/compliance/' },
      { text: 'Legal', link: '/legal/privacy-policy' },
      { text: 'fseven.ai', link: 'https://fseven.ai' },
    ],

    sidebar: {
      '/overview/': [
        {
          text: 'Overview',
          items: [
            { text: 'What Is F7?', link: '/overview/what-is-f7' },
            { text: 'How It Works', link: '/overview/how-it-works' },
            { text: 'Data We Collect', link: '/overview/data-we-collect' },
          ],
        },
      ],
      '/security/': [
        {
          text: 'Security',
          items: [
            { text: 'Security Overview', link: '/security/' },
            { text: 'Architecture', link: '/security/architecture' },
            { text: 'Authorization', link: '/security/authorization' },
            { text: 'Encryption', link: '/security/encryption' },
            { text: 'Agent Security', link: '/security/agent-security' },
          ],
        },
      ],
      '/privacy/': [
        {
          text: 'Privacy',
          items: [
            { text: 'Privacy Principles', link: '/privacy/' },
            { text: 'Data Collection Details', link: '/privacy/data-collection' },
            { text: 'Employee Controls', link: '/privacy/employee-controls' },
            { text: 'Data Retention & Deletion', link: '/privacy/data-retention' },
          ],
        },
      ],
      '/compliance/': [
        {
          text: 'Compliance',
          items: [
            { text: 'Compliance Overview', link: '/compliance/' },
            { text: 'GDPR', link: '/compliance/gdpr' },
            { text: 'CCPA / CPRA', link: '/compliance/ccpa' },
            { text: 'SOC 2', link: '/compliance/soc2' },
          ],
        },
      ],
      '/legal/': [
        {
          text: 'Legal',
          items: [
            { text: 'Privacy Policy', link: '/legal/privacy-policy' },
            { text: 'Terms of Service', link: '/legal/terms-of-service' },
            { text: 'Data Processing Agreement', link: '/legal/dpa' },
            { text: 'Sub-processors', link: '/legal/subprocessors' },
          ],
        },
      ],
      '/': [
        {
          text: 'Trust Center',
          items: [
            { text: 'Home', link: '/' },
            { text: 'FAQ', link: '/faq' },
          ],
        },
        {
          text: 'Quick Links',
          items: [
            { text: 'What Is F7?', link: '/overview/what-is-f7' },
            { text: 'Data We Collect', link: '/overview/data-we-collect' },
            { text: 'Security Overview', link: '/security/' },
            { text: 'Privacy Principles', link: '/privacy/' },
            { text: 'Compliance', link: '/compliance/' },
          ],
        },
      ],
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/f7-platform/public-docs' },
    ],

    footer: {
      message: 'Published by F7 Platform, Inc.',
      copyright: 'Copyright © 2025–2026 F7 Platform, Inc. All rights reserved.',
    },

    search: {
      provider: 'local',
    },

    editLink: {
      pattern: 'https://github.com/f7-platform/public-docs/edit/main/content/:path',
      text: 'Edit this page on GitHub',
    },
  },
})
