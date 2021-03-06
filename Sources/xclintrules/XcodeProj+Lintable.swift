import xcproj

extension XcodeProj: Lintable {
    
    // MARK: - Public
    
    public func lint() -> [LintError] {
        var errors: [LintError] = []
        errors.append(contentsOf: lintDuplicates())
        errors.append(contentsOf: pbxproj.buildFiles.flatMap({ $0.lint(project: pbxproj) }))
        errors.append(contentsOf: pbxproj.aggregateTargets.flatMap({ $0.lint(project: pbxproj) }))
        errors.append(contentsOf: pbxproj.nativeTargets.flatMap({ $0.lint(project: pbxproj) }))
        errors.append(contentsOf: pbxproj.containerItemProxies.flatMap({ $0.lint(project: pbxproj) }))
        errors.append(contentsOf: pbxproj.groups.flatMap({ $0.lint(project: pbxproj) }))
        errors.append(contentsOf: pbxproj.configurationLists.flatMap({ $0.lint(project: pbxproj) }))
        errors.append(contentsOf: pbxproj.variantGroups.flatMap({ $0.lint(project: pbxproj) }))
        errors.append(contentsOf: pbxproj.targetDependencies.flatMap({ $0.lint(project: pbxproj) }))
        errors.append(contentsOf: pbxproj.projects.flatMap({ $0.lint(project: pbxproj) }))
        return errors
    }
    
    // MARK: - Fileprivate
    
    fileprivate func lintDuplicates() -> [LintError] {
        // FIXME: When the .pbxproj is parsed duplicated entries are automatically removed.
        // As a result this lint has no effect.
        return pbxproj.objects
            .reduce(into: [String: [PBXObject]](), { $0[$1.reference, default: []].append($1) })
            .filter({ $0.value.count != 1 })
            .map { (reference, _) -> LintError in
                return LintError.duplicatedReference(reference: reference)
            }
    }
    
}
