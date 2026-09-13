import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'F7 Trust Center',
  description: 'Security, privacy, and compliance documentation for Atlas by F7.',
  srcDir: 'content',
  base: '/public-docs/',
  cleanUrls: true,
  lastUpdated: true,

  head: [
    ['meta', { name: 'theme-color', content: '#1a56db' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:title', content: 'F7 Trust Center' }],
    ['meta', { property: 'og:description', content: 'Security, privacy, and compliance documentation for Atlas by F7.' }],
    ['meta', { property: 'og:url', content: 'https://f7-platform.github.io/public-docs/' }],
  ],

  themeConfig: {
    siteTitle: 'F7 Trust Center',

    nav: [
      { text: 'Overview', link: '/overview/what-is-atlas' },
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
            { text: 'What Is Atlas?', link: '/overview/what-is-atlas' },
            { text: 'How Atlas Runs', link: '/overview/how-it-works' },
            { text: 'What Atlas Holds', link: '/overview/data-we-collect' },
          ],
        },
      ],
      '/security/': [
        {
          text: 'Security',
          items: [
            { text: 'Security Overview', link: '/security/' },
            { text: 'Deployment and Trust Architecture', link: '/security/architecture' },
            { text: 'Accounts and Access', link: '/security/authorization' },
            { text: 'Encryption and Signing', link: '/security/encryption' },
            { text: 'Downloads and Updates', link: '/security/downloads' },
          ],
        },
      ],
      '/privacy/': [
        {
          text: 'Privacy',
          items: [
            { text: 'Privacy Principles', link: '/privacy/' },
            { text: 'Data Atlas Holds (Details)', link: '/privacy/data-collection' },
            { text: 'Your Controls', link: '/privacy/your-controls' },
            { text: 'Data Retention and Deletion', link: '/privacy/data-retention' },
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
            { text: 'Claims Registry', link: '/compliance/claims-registry' },
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
            { text: 'What Is Atlas?', link: '/overview/what-is-atlas' },
            { text: 'What Atlas Holds', link: '/overview/data-we-collect' },
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
