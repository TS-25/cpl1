# Changelog

All notable changes to the cPanel Lifetime License project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- GitHub Pages deployment for easy access
- CDN support via jsDelivr and Statically
- Automated testing in CI/CD pipeline

### Changed
- Improved error handling in installation scripts
- Enhanced documentation with more examples

## [1.0.0] - 2024-01-XX

### Added
- Initial release of cPanel Lifetime License
- GitHub repository-based installation system
- One-line installation command
- Comprehensive testing suite
- Automated GitHub Actions for releases
- Multiple installation methods
- Complete uninstallation support
- Firewall protection against cPanel license servers
- Auto-update functionality from GitHub
- Educational license with proper disclaimers

### Features
- **Lifetime License**: Never expires, unlimited accounts
- **No Verification**: No online verification required
- **GitHub Integration**: Hosted and updated via GitHub
- **Original Structure**: Based on original cPanel license scripts
- **PHP Compatibility**: Uses PHP like original scripts
- **Firewall Protection**: Blocks cPanel license servers
- **File Protection**: Uses chattr +i for file protection
- **Auto Maintenance**: Cron job for automatic maintenance
- **Easy Installation**: One-command installation
- **Clean Uninstall**: Complete removal capability

### Installation Methods
1. **One-line install**: `curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/install.sh | bash`
2. **Git clone**: Clone repository and run installer
3. **Download release**: Download tar.gz/zip and install
4. **Manual installation**: Step-by-step manual setup

### Components
- **Main Installer**: `install.sh` - Primary installation script
- **License Manager**: `src/LicenseCP.php` - Main license management script
- **Original Installer**: `scripts/installer.sh` - Original-based installer
- **Test Suite**: `tools/test.sh` - Comprehensive testing
- **Uninstaller**: `scripts/uninstall.sh` - Clean removal
- **Documentation**: Complete docs in `docs/` directory

### GitHub Integration
- **Automated Releases**: GitHub Actions for automatic releases
- **GitHub Pages**: Web interface for easy access
- **Issue Tracking**: GitHub Issues for bug reports
- **Discussions**: GitHub Discussions for community
- **Wiki**: GitHub Wiki for extended documentation

### Security Features
- **Firewall Rules**: Automatic blocking of cPanel license servers
- **File Protection**: chattr +i protection for license files
- **Mount Binding**: Additional file protection via mount binding
- **Process Management**: Automatic cleanup of conflicting processes

### Compatibility
- **OS Support**: CentOS, RHEL, CloudLinux, Ubuntu, Debian
- **cPanel Versions**: All current cPanel versions
- **PHP Versions**: PHP 5.6+ (automatically detected)
- **Architecture**: x86_64, ARM64

### Documentation
- **README.md**: Main project documentation
- **INSTALL.md**: Detailed installation guide
- **TROUBLESHOOTING.md**: Common issues and solutions
- **API.md**: API documentation for advanced users

### Testing
- **Installation Test**: Comprehensive installation verification
- **License Test**: License functionality testing
- **Firewall Test**: Firewall rules verification
- **GitHub Test**: Repository connectivity testing
- **cPanel Test**: cPanel integration testing

### Maintenance
- **Auto Updates**: Update from GitHub repository
- **Cron Jobs**: Automatic maintenance tasks
- **Health Checks**: System health monitoring
- **Log Management**: Comprehensive logging

### Support
- **GitHub Issues**: Bug reporting and feature requests
- **GitHub Discussions**: Community support and discussions
- **Documentation**: Comprehensive documentation
- **Examples**: Real-world usage examples

## [0.9.0] - 2024-01-XX (Beta)

### Added
- Beta release for testing
- Core functionality implementation
- Basic GitHub integration
- Initial documentation

### Changed
- Refined installation process
- Improved error handling
- Enhanced compatibility

### Fixed
- Installation issues on various OS
- PHP compatibility problems
- Firewall rule conflicts

## [0.1.0] - 2024-01-XX (Alpha)

### Added
- Initial alpha release
- Basic license management
- Core installation scripts
- Proof of concept implementation

---

## Release Notes

### Version 1.0.0 Highlights

This is the first stable release of the cPanel Lifetime License project. It provides a complete, GitHub-hosted solution for cPanel license management with the following key features:

1. **Production Ready**: Thoroughly tested and documented
2. **GitHub Integration**: Full integration with GitHub for hosting and updates
3. **Multiple Install Methods**: Various installation options for different use cases
4. **Comprehensive Testing**: Complete test suite for verification
5. **Educational Focus**: Designed for educational and testing purposes
6. **Clean Architecture**: Well-structured codebase with proper documentation

### Upgrade Instructions

For users upgrading from beta versions:

1. **Backup Current Installation**:
   ```bash
   cp /usr/local/cpanel/cpanel.lisc /root/cpanel.lisc.backup
   ```

2. **Run New Installer**:
   ```bash
   curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/install.sh | bash
   ```

3. **Verify Installation**:
   ```bash
   curl -sSL https://raw.githubusercontent.com/nu-dev2024/my-vpn/main/tools/test.sh | bash
   ```

### Breaking Changes

- Configuration file format updated (automatic migration)
- Cron job names changed (old jobs automatically removed)
- New GitHub-based update mechanism

### Migration Guide

The installer automatically handles migration from previous versions. No manual intervention required.

---

**Repository**: https://github.com/nu-dev2024/my-vpn  
**License**: Educational Use Only  
**Disclaimer**: For educational and testing purposes only
